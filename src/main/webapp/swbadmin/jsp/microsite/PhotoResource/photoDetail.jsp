<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.lib.*,java.text.*,org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
            java.text.SimpleDateFormat dateFormat;


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

            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
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
            //String lang = user.getLanguage();

            String uri = request.getParameter("uri");
            PhotoElement photo = (PhotoElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
            if (photo == null)
            {
                response.sendError(404);
                return;
            }
            DecimalFormat df = new DecimalFormat("#0.0#");
            String rank = df.format(photo.getRank());
            if (photo != null && photo.canView(member))
            {
                photo.incViews();  //Incrementar apariciones
                String title = "";
                if (photo.getTitle() != null)
                {
                    title = photo.getTitle().replace("'", "\\'");
                }
                String description = "";
                if (photo.getDescription() != null)
                {
                    description = photo.getDescription().replace("'", "\\'");
                }
                String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/PhotoResource/sinfoto.png";
                String path = photo.getWorkPath();
                if (photo.getPhotoThumbnail() != null)
                {
                    int pos = photo.getPhotoThumbnail().lastIndexOf("/");
                    if (pos != -1)
                    {
                        String sphoto = photo.getPhotoThumbnail().substring(pos + 1);
                        photo.setPhotoThumbnail(sphoto);
                    }
                    pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + photo.getPhotoThumbnail();
                }

                String imgPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/PhotoResource/sinfoto.png";
                if (photo.getImageURL() != null)
                {
                    int pos = photo.getImageURL().lastIndexOf("/");
                    if (pos != -1)
                    {
                        String sphoto = photo.getImageURL().substring(pos + 1);
                        photo.setImageURL(sphoto);
                    }
                    imgPhoto = SWBPortal.getWebWorkPath() + path + "/" + photo.getImageURL();
                }
%>
<div class="columnaIzquierda">
    <h2>
        <script type="text/javascript">
            <!--
            document.write('<%=title%>');
            -->
        </script></h2><br/>
    <p><script type="text/javascript">
        <!--
        document.write('<%= description%>');
        -->
        </script></p>
    <p><a title="<%= title%>" href="<%= imgPhoto%>">
            <img id="img_<%=photo.getId()%>" src="<%= pathPhoto%>" alt="<%=title%>" width="150" height="150" />
        </a></p>            

    <%
            }

            SWBResponse res = new SWBResponse(response);
            photo.renderGenericElements(request, res, paramRequest);
            out.write(res.toString());
            String postAuthor = "Usuario dado de baja";
            if (photo.getCreator() != null)
            {
                postAuthor = photo.getCreator().getFirstName();
            }
    %>
</div>
<div class="columnaCentro">
    <p>&nbsp;</p>
    <p>Autor: <%= postAuthor%></p>
    <p>Creado el: <%=dateFormat.format(photo.getCreated())%></p>
    <p><%= photo.getViews()%> vistas</p>
    <p>Calificación: <%=rank%></p>
    <p><a href="<%=paramRequest.getRenderUrl()%>">[Ver todas las fotos]</a></p>
    <%if (photo.canModify(member))
            {%>
    <p><a href="<%=paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", photo.getURI())%>">[Editar información]</a></p>
    <%}%>
    <%if (photo.canModify(member) || isAdministrator)
            {%>
    <p><a href="<%=paramRequest.getActionUrl().setParameter("act", "remove").setParameter("uri", photo.getURI())%>">[Eliminar]</a></p>
    <%}%>
    <ul class="miContenido">
        <%
            SWBResourceURL urla = paramRequest.getActionUrl();
            if (user.isRegistered())
            {
                if (member == null)
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a esta comunidad</a></li>
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
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?photo=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de fotos de la comunidad</a></li>
    </ul>
</div>