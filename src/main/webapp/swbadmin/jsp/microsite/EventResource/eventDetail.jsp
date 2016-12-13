<%@page contentType="text/html"%>
<%@page import="java.util.*,org.semanticwb.portal.lib.*,java.text.SimpleDateFormat, org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            Resource base = paramRequest.getResourceBase();
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);
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
            String uri = request.getParameter("uri");
            EventElement event = (EventElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
            if (event == null)
            {
                response.sendError(404);
                return;
            }
            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm a");
            String rank = df.format(event.getRank());
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
            String place = "";
            if (event != null && event.getPlace() != null)
            {
                place = event.getPlace().replace("'", "\\'");
            }
            String audience = "";
            if (event != null && event.getAudienceType() != null)
            {
                audience = event.getAudienceType().replace("'", "\\'");
            }
            if (event != null && event.canView(member))
            {
                String comienza = "Sin determinar";
                String termina = "Sin determinar";

                String hcomienza = "Sin determinar";
                String htermina = "Sin determinar";
                try
                {
                    comienza = event.getStartDate() == null ? "Sin determinar" : dateFormat.format(event.getStartDate());

                }
                catch (Exception e)
                {
                }
                try
                {

                    termina = event.getEndDate() == null ? "Sin determinar" : dateFormat.format(event.getEndDate());
                }
                catch (Exception e)
                {
                }
                try
                {
                    hcomienza = event.getStartTime() == null ? "Sin determinar" : timeFormat.format(event.getStartTime());

                }
                catch (Exception e)
                {
                }
                try
                {

                    htermina = event.getEndTime() == null ? "Sin determinar" : timeFormat.format(event.getEndTime());
                }
                catch (Exception e)
                {
                }
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
                String imgPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";
                if (event.getEventImage() != null)
                {
                    int pos = event.getEventImage().lastIndexOf("/");
                    if (pos != -1)
                    {
                        String sphoto = event.getEventImage().substring(pos + 1);
                        event.setEventImage(sphoto);
                    }
                    imgPhoto = SWBPortal.getWebWorkPath() + path + "/" + event.getEventImage();
                }



%>
<div class="columnaIzquierda">
    <%
                if (event != null && event.canView(member))
                {
                    event.incViews();

    %>
    <h2>
        <script type="text/javascript">
            <!--
            document.write('<%= title%>');
            -->
        </script>
    </h2>
    <p>
        <script type="text/javascript">
            <!--
            document.write('<%= description%>');
            -->
        </script></p>
    <p>
        <a href="<%= imgPhoto%>">
            <img id="img_<%=event.getId()%>" src="<%= pathPhoto%>" alt="<%=event.getTitle()%>" width="150" height="150" />
        </a>
    </p>
    <p><span class="itemTitle">Comienza:</span> <%= comienza%> a las <%= hcomienza%><br/>
        <span class="itemTitle">Termina:&nbsp;&nbsp;&nbsp;</span> <%= termina%> a las <%= htermina%></p>

    <br/>
    <%
                }
                SWBResponse res = new SWBResponse(response);
                event.renderGenericElements(request, res, paramRequest);
                out.write(res.toString());
            }
    %>

</div>
<div class="columnaCentro">        


    <%
            try
            {
                GregorianCalendar cal = new GregorianCalendar(new Locale("es"));
                SimpleDateFormat sf = new SimpleDateFormat("MMMM", new Locale("es"));
                String smonth = sf.format(event.getStartDate());
                smonth = smonth.substring(0, 1).toUpperCase() + smonth.substring(1);
                cal.setTime(event.getStartDate());
                int year = cal.get(cal.YEAR);
    %>
    <div id="calendario">
        <h2><%=smonth%> del <%=year%></h2>
        <ul class="dias semana">
            <li>D</li><li>L</li><li>M</li><li>M</li><li>J</li><li>V</li><li>S</li>
        </ul>
        <%

                cal.setTime(event.getStartDate());
                java.util.Calendar cend = java.util.Calendar.getInstance();
                cend.setTime(event.getEndDate());
                java.util.Calendar cinit = java.util.Calendar.getInstance();
                cinit.setTime(event.getStartDate());
        %>
        <ul class="dias">
            <%
                int inicio = 1;
                int fin = cal.getActualMaximum(cal.DAY_OF_MONTH);
                cal.set(cal.DAY_OF_MONTH, 1);
                int offset = cal.get(cal.DAY_OF_WEEK) - cal.SUNDAY;
                for (int i = 1; i <= offset; i++)
                {
            %>
            <li>&nbsp;</li>
            <%                }
                for (int i = inicio; i <= fin; i++)
                {
                    boolean active = false;
                    cal.set(cal.DAY_OF_MONTH, i);
                    if (cal.compareTo(cinit) >= 0 && cal.compareTo(cend) <= 0)
                    {
                        active = true;
                    }
                    if (active)
                    {
            %>
            <li><a href="#"><%=i%></a></li>
            <%
                    }
                    else
                    {
            %>
            <li><%=i%></li>
            <%

                    }
                }
            %>            
        </ul>

        <div class="clear">&nbsp;</div>
    </div>
    <%
            }
            catch (Exception e)
            {
            }
    %>
    <p>Audiencia:  <script type="text/javascript">
        <!--
        document.write('<%= audience%>');
        -->
        </script></p>
    <p>Lugar: <strong>
            <script type="text/javascript">
                <!--
                document.write('<%= place%>');
                -->
            </script></strong></p>
    <p>Asistentes:
        <%
            Iterator<User> users = event.listAttendants();
            while (users.hasNext())
            {
                User m = users.next();
        %>
        <%= m.getFullName()%>
        <%
                if (users.hasNext())
                {
        %>,&nbsp;<%            }
            }
        %>
    </p>
    <p>Creado el: <%=dateFormat.format(event.getCreated())%></p>
    <p><%=event.getViews()%> vistas</p>
    <p>Calificación: <%=rank%></p>
    <%
            SWBResourceURL back = paramRequest.getRenderUrl().setParameter("act", "view");
            back = paramRequest.getRenderUrl().setParameter("act", "edit");
            back.setParameter("year", request.getParameter("year"));
            back.setParameter("month", request.getParameter("month"));
            back.setParameter("day", request.getParameter("day"));
            back.setParameter("uri", event.getURI());
    %>
    <p><a href="<%= paramRequest.getRenderUrl()%>">[Ver todos los eventos]</a></p>
    <%
            boolean issuscribed = false;
            Iterator<EventElement> it = EventElement.ClassMgr.listEventElementByAttendant(user, paramRequest.getWebPage().getWebSite());
            while (it.hasNext())
            {
                EventElement element = it.next();
                if (element.getURI().equals(event.getURI()))
                {
                    issuscribed = true;
                    break;
                }
            }
            if (event.canView(member) && !issuscribed)
            {


    %>
    <p><a href="<%=paramRequest.getActionUrl().setParameter("act", "attend").setParameter("uri", event.getURI()).toString(true)%>">[Asistir al evento]</a></p>
    <%  }
    %>
    <%
            if (event.canModify(member))
            {
    %>
    <p><a href="<%= back%>">[Editar información]</a></p>
    <%
            }
            if (event.canModify(member) || isAdministrator)
            {
    %>
    <p><a href="<%= paramRequest.getActionUrl().setParameter("act", "remove").setParameter("uri", event.getURI())%>">[Eliminar]</a></p>
    <%
            }%>

    <ul class="miContenido">
        <%
            SWBResourceURL urla = paramRequest.getActionUrl();
            if (user.isRegistered())
            {
                if (member == null)
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a esta comunidad a comunidad</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a comunidad</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?event=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de eventos de la comunidad</a></li>
    </ul>
</div>