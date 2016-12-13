<%@page contentType="text/html"%>
<%@page import="java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>
<%
            String lang = "es";
            Locale locale = new Locale(lang);
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            //MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            Member member = Member.getMember(user, wpage);
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy", locale);            
            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");            
            String year = request.getParameter("y");
            String month = request.getParameter("m");
            String day = request.getParameter("d");
            Date current = null;

            if (day != null && month != null && year != null)
            {
                current = new Date(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day));
            }
            if (user.getLanguage() != null)
            {
                lang = user.getLanguage();
            }
%>

<div class="columnaIzquierda">


    <%
            Iterator<EventElement> it;

            if (current == null)
            {
                it = EventElement.ClassMgr.listEventElementByAttendant(user, paramRequest.getWebPage().getWebSite());
            }
            else
            {
                it = EventElement.listEventElementsByDate(user, current, wpage, wpage.getWebSite());
            }

            java.util.Calendar today = java.util.Calendar.getInstance();
            today.setTime(new Date(System.currentTimeMillis()));
            today.set(today.HOUR_OF_DAY, 23);
            today.set(today.MINUTE, 59);
            today.set(today.SECOND, 59);
            today.set(today.MILLISECOND, 00);
            java.util.Calendar end = java.util.Calendar.getInstance();

            while (it.hasNext())
            {
                EventElement event = it.next();
                end.setTime(event.getEndDate());
                end.add(end.MONTH, 1);
                if (today.after(end) || today.equals(end))
                {
                    event.remove();
                }
            }
            ArrayList<EventElement> elements = new ArrayList();
            int elementos = 0;
            if (current == null)
            {
                it = EventElement.ClassMgr.listEventElementByAttendant(user, paramRequest.getWebPage().getWebSite());
            }
            else
            {
                it = EventElement.listEventElementsByDate(user, current, wpage, wpage.getWebSite());
            }
            it = SWBComparator.sortByCreated(it, false);
            boolean hasEvents = false;
            while (it.hasNext())
            {
                EventElement event = it.next();
                end.setTime(event.getEndDate());
                end.set(end.HOUR_OF_DAY, 23);
                end.set(end.MINUTE, 59);
                end.set(end.SECOND, 59);
                end.set(end.MILLISECOND, 00);
                if (event.canView(member) && !today.after(end))
                {
                    elements.add(event);
                    elementos++;
                }
                else
                {
                    System.out.println("end date" + end.getTime());
                    System.out.println("today " + today.getTime());
                }


            }
            int paginas = elementos / ELEMENETS_BY_PAGE;
            if (elementos % ELEMENETS_BY_PAGE != 0)
            {
                paginas++;
            }
            int inicio = 0;
            int fin = ELEMENETS_BY_PAGE;
            int ipage = 1;
            if (request.getParameter("ipage") != null)
            {
                try
                {
                    ipage = Integer.parseInt(request.getParameter("ipage"));
                    inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
                    fin = (ipage * ELEMENETS_BY_PAGE);
                }
                catch (NumberFormatException nfe)
                {
                    ipage = 1;
                }
            }
            if (ipage < 1 || ipage > paginas)
            {
                ipage = 1;
            }
            if (inicio < 0)
            {
                inicio = 0;
            }
            if (fin < 0)
            {
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin > elementos)
            {
                fin = elementos;
            }
            if (inicio > fin)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin - inicio > ELEMENETS_BY_PAGE)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            inicio++;
    %>
    <!-- paginacion -->
    <%
            if (paginas > 1)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %>
            <strong>
                <%                            }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                            }
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->
    <%
            int iElement = 0;
            for (EventElement event : elements)
            {

                String viewUrl = event.getURL();
                String rank = df.format(event.getRank());
                if (event.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        hasEvents = true;
                        String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/EventResource/noevent.jpg";
                        String path = event.getWorkPath();
                        if (event.getEventThumbnail() != null)
                        {
                            int pos = event.getEventThumbnail().lastIndexOf("/");
                            if (pos != -1)
                            {
                                String sphoto = event.getEventThumbnail().substring(pos + 1);
                                event.setEventThumbnail(sphoto);
                            }
                            pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + event.getEventThumbnail();
                        }
                        String postAuthor = "Usuario dado de baja";
                        if (event.getCreator() != null)
                        {
                            postAuthor = event.getCreator().getFirstName();
                        }
    %>
    <div class="noticia">
        <img src="<%=pathPhoto%>" alt="<%= event.getTitle()%>"/>
        <div class="noticiaTexto">
            <h2><%=event.getTitle()%></h2>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(event.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(event.getCreated(), user.getLanguage())%></p>
            <p>
                <%=event.getDescription()%> | <a href="<%=viewUrl%>">Ver más</a>
            </p>
            <p class="stats">
            	Puntuación: <%=rank%><br/>
                <%=event.getViews()%> vistas
            </p>
        </div>
    </div>   

    <%                  }
                }
            }
    %>
    <%
            if (!hasEvents)
            {
    %>
    <p>No hay eventos registrados, aqui se muestran los eventos  de comunidad a los que esta inscrito.</p>
    <%            }
    %>
    <!-- paginacion -->
    <%
            if (paginas > 1)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %>
            <strong>
                <%                            }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                            }
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->
</div>
<div class="columnaCentro"></div>