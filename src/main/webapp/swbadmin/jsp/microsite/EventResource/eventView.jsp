<%@page contentType="text/html"%>
<%@page import="org.semanticwb.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar el evento: '+title+'?'))
        {            
            window.location.href=url;
        }
    }
</script>

<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>
<%
            java.text.SimpleDateFormat dateFormat;
            java.text.SimpleDateFormat timeFormat = new java.text.SimpleDateFormat("HH:mm");


            String lang = "es";
            Locale locale = new Locale(lang);
            dateFormat = new java.text.SimpleDateFormat("dd-MMM-yyyy", locale);
            String[] months =
            {
                "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
            };
            java.text.DateFormatSymbols fs = dateFormat.getDateFormatSymbols();
            fs.setShortMonths(months);
            dateFormat.setDateFormatSymbols(fs);

            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");

            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
            Member member = Member.getMember(user, wpage);
            String addEventURL = paramRequest.getRenderUrl().setParameter("act", "add").toString();
            boolean isAdministrator = false;
            if (user != null)
            {
                GenericIterator<UserGroup> groups = user.listUserGroups();
                while (groups.hasNext())
                {
                    UserGroup group = groups.next();
                    if (group != null && group.getId().equals("admin"))
                    {
                        isAdministrator = true;
                        break;
                    }
                }
            }

            java.util.Calendar today = java.util.Calendar.getInstance();
            today.setTime(new Date(System.currentTimeMillis()));
            today.set(today.HOUR_OF_DAY, 23);
            today.set(today.MINUTE, 59);
            today.set(today.SECOND, 59);
            today.set(today.MILLISECOND, 00);


            java.util.Calendar end = java.util.Calendar.getInstance();

            Iterator<EventElement> it = EventElement.ClassMgr.listEventElementByEventWebPage(wpage, wpage.getWebSite());
            while (it.hasNext())
            {

                EventElement event = it.next();
                try
                {
                    if (event != null && event.getEndDate() != null)
                    {
                        end.setTime(event.getEndDate());
                        end.add(end.MONTH, 1);
                        if (today.after(end) || today.equals(end))
                        {
                            event.remove();
                        }
                    }
                }
                catch (RuntimeException e)
                {
                    SWBUtils.getLogger(this.getClass()).error(e);
                }
            }
            ArrayList<EventElement> elements = new ArrayList();
            int elementos = 0;

            it = EventElement.ClassMgr.listEventElementByEventWebPage(wpage, wpage.getWebSite());
            it = SWBComparator.sortByCreated(it, false);
            while (it.hasNext())
            {
                EventElement event = it.next();
                try
                {
                    if (event != null && event.getEndDate() != null)
                    {
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
                    }
                }
                catch (RuntimeException e)
                {
                    if (event.canView(member))
                    {
                        elements.add(event);
                        elementos++;
                    }
                    SWBUtils.getLogger(this.getClass()).error(e);
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
<div class="columnaIzquierda">


    <%
            if (paginas > 1)
            {
    %>
    <div id="paginacion">


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
                <%                    }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                    }
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

    <div class="adminTools">
        <%SWBResourceURL u = paramRequest.getRenderUrl().setParameter("act", "calendar");%>
        <!--a class="adminTool" href="%=u%>">Ver calendario</a-->
        <%
            if (member.canAdd())
            {
        %>
        <a class="adminTool" href="<%=addEventURL%>">Agregar evento</a>
        <%
            }
        %>
    </div>
    <%

            if (elements.size() == 0)
            {
    %>
    <p>No hay eventos registrados en la comunidad</p>
    <%            }

            int iElement = 0;
            for (EventElement event : elements)
            {

                SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", event.getURI());
                if (event.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        String fechaEvento = "Sin determinar";
                        try
                        {
                            fechaEvento = dateFormat.format(event.getStartDate());
                        }
                        catch (Exception e)
                        {
                        }
                        String hfechaEvento = "Sin determinar";
                        try
                        {
                            hfechaEvento = timeFormat.format(event.getStartTime());
                        }
                        catch (Exception e)
                        {
                        }
                        String rank = df.format(event.getRank());
                        String editEventURL = paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", event.getURI()).toString();
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", event.getEncodedURI());
                        String removeurl = "javascript:validateremove('" + removeUrl + "','" + event.getTitle() + "')";

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
                        String title = "";
                        if (event != null && event.getTitle() != null)
                        {
                            title = event.getTitle().replace("'", "\\'");
                        }
                        String description = "";
                        if (event != null && event.getDescription() != null)
                        {
                            description = event.getDescription().replace("'", "\\'");
                        }
    %>
    <div class="noticia">
        <img src="<%=pathPhoto%>" width="150" height="150" alt="<%= event.getTitle()%>"/>
        <div class="noticiaTexto">
            <h2>
                <script type="text/javascript">
                    <!--
                    document.write('<%=title%>');
                    -->
                </script>

            </h2>
            <p>Fecha del evento: <%=fechaEvento%> a las <%=hfechaEvento%><br/>
                &nbsp;<br/>Por: <%=postAuthor%><br/>Creado el: <%=dateFormat.format(event.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(event.getCreated(), user.getLanguage())%></p>
            <p>
                <script type="text/javascript">
                    <!--
                    document.write('<%=description%>');
                    -->
                </script> | <a href="<%=viewUrl.toString(true)%>">Ver más</a>
                <%
                        if (event.canModify(member))
                        {
                %>
                | <a href="<%=editEventURL%>">Editar</a>
                <%
                        }
                %>
                <%
                        if (event.canModify(member) || isAdministrator)
                        {
                %>
                | <a href="<%=removeurl%>">Eliminar</a>
                <%
                        }
                %>

            </p>
            <p class="stats">
            	Puntuación: <%=rank%><br/>
                <%=event.getViews()%> vistas
            </p>
        </div>
    </div>
    <%
                    }
                }
            }
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
<div class="columnaCentro">
    <%
            if (paginas > 1)
            {
    %>
    <br/><br/>
    <%            }
    %>
    <ul class="miContenido">
        <%
            SWBResourceURL urla = paramRequest.getActionUrl();

            if (member.canView())
            {
                if (!wputil.isSubscribed(member))
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a eventos de la comunidad</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a eventos</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?event=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de eventos de la comunidad</a></li>
    </ul>
    <%
            if (!wputil.isSubscribed(member))
            {
    %>
    <br/><br/><p><span class="tituloRojo">NOTA: </span>Si se suscribe a los eventos de la comunidad, recibirá una notificación por correo electrónico cuando algún miembro agrege o modifique algún evento.</p>
    <%            }
    %>

</div>
