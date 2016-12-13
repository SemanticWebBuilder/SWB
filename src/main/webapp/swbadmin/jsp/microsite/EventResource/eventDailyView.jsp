<%@page contentType="text/html"%>
<%@page import="java.util.Date, java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    Resource base = paramRequest.getResourceBase();
    User user = paramRequest.getUser();
    String day = request.getParameter("day");
    String month = request.getParameter("month");
    String year = request.getParameter("year");
    WebPage wpage = paramRequest.getWebPage();
    MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
    Member member = Member.getMember(user, wpage);
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
    SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss a");
    String addEventURL = paramRequest.getRenderUrl().setParameter("act", "add").toString();
    SWBResourceURL listURL = paramRequest.getRenderUrl().setParameter("act", "calendar");
    listURL.setParameter("day", day);
    listURL.setParameter("month", month);
    listURL.setParameter("year", year);
    String lang = "es";
    Locale locale = new Locale(lang);
    dateFormat = new SimpleDateFormat("dd-MMM-yyyy", locale);
%>

<%!
private static final int ELEMENETS_BY_PAGE = 5;
%>

<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" href="<%=listURL.toString()%>">Regresar</a>
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
    Date dNow = new Date(Integer.valueOf(year) - 1900, Integer.valueOf(month), Integer.valueOf(day));

    Iterator<EventElement> eit = EventElement.listEventElementsByDate(null, dNow, wpage, wpage.getWebSite());
    while(eit.hasNext()) {
        EventElement event = eit.next();
        if(event.canView(member)) {
            SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", event.getURI());
            viewUrl.setParameter("year", year);
            viewUrl.setParameter("month", month);
            viewUrl.setParameter("day", day);

            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");
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
%>
    <div class="noticia">
        <img src="<%=pathPhoto%>" alt="<%= event.getTitle()%>"/>
        <div class="noticiaTexto">
            <h2><%=event.getTitle()%></h2>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(event.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(event.getCreated(), user.getLanguage())%></p>
            <p>
                <%=event.getDescription()%> | <a href="<%=viewUrl%>">Ver más</a>
                <%
                        if (event.canModify(member))
                        {
                %>
                | <a href="<%=editEventURL%>">Editar</a> | <a href="<%=removeurl%>">Eliminar</a>
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
    SWBResourceURL back = paramRequest.getRenderUrl();
    back.setParameter("year", year);
    back.setParameter("month", month);
    back.setParameter("day", day);
%>
</div>