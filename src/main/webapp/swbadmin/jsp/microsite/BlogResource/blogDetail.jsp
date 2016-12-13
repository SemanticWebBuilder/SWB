<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.lib.*,java.text.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<script type="text/javascript">
    <!--
    function validateremove(url, title,uri)
    {
        if(confirm('¿Esta seguro de borrar la entrada '+title+'?'))
        {
            var url=url+'&amp;uri='+escape(uri);
            window.location.href=url;
        }
    }
    -->
</script>

<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            if (paramRequest == null)
            {
                return;
            }
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            PostElement post = (PostElement) request.getAttribute("post");
            if (post == null)
            {
                response.sendError(404);
                return;
            }
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
            if (!post.canView(member) || post == null)
            {
%>
<p>No tiene permisos para ver esta entrada, o la entrada ya no existe</p>
<%
                return;
            }


            String updated = SWBUtils.TEXT.getTimeAgo(post.getUpdated(), user.getLanguage());
            String postAuthor = "Usuario dado de baja";
            if (post.getCreator() != null)
            {
                postAuthor = post.getCreator().getFirstName();
            }
            post.incViews();  //Incrementar apariciones
            DecimalFormat df = new DecimalFormat("#0.0#");
            String rank = df.format(post.getRank());
            SWBResourceURL removeUrl = paramRequest.getActionUrl();
            removeUrl.setParameter("act", "remove");
            boolean canadd = post.canModify(member);
            String editURL = paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", post.getURI()).setParameter("mode", "editpost").toString();
            String deleteUrl = "javascript:validateremove('" + removeUrl + "','" + post.getTitle() + "','" + post.getURI() + "')";
            String title = "Sin titulo";
            if (post.getTitle() != null)
            {
                title = post.getTitle().replace("'", "\\'");
            }
            String description = "";
            if (post != null && post.getDescription() != null)
            {
                description = post.getDescription().replace("'", "\\'");
            }
            String content = "";
            if (post != null && post.getContent() != null)
            {
                content = post.getContent().replace("'", "\\'");
            }
%>

<div class="columnaIzquierda">    
    <h2 class="hidden">
        <script type="text/javascript">
            <!--
            document.write('<%=title%>');
            -->
        </script>

    </h2>
            <div style="margin-left: 5px;margin-right: 5px">
            <p >
        <%=content%>

    </p>
    </div>
    <br/>
    <br/>

    <%
            SWBResponse res = new SWBResponse(response);
            post.renderGenericElements(request, res, paramRequest);
            out.write(res.toString());
    %>
</div>
<div class="columnaCentro">
    <h2 class="blogTitle">
        <script type="text/javascript">
            <!--
            document.write('<%=title%>');
            -->
        </script></h2>
    <p>

        <script type="text/javascript">
            <!--
            document.write('<%=description%>');
            -->
        </script>
    </p>
    <p> Autor: <%=postAuthor%> </p>
    <p> Actualizado: <%=updated%> </p>
    <p> Calificación: <%=rank%> </p>
    <p> <%=post.getViews()%> visitas  </p>
    <p><a href="<%=paramRequest.getRenderUrl()%>">[Ver todas las entradas del blog]</a></p>
    <%
            if (canadd)
            {
    %>
    <p><a href="<%=editURL%>">[Editar Entrada]</a></p>

    <%
            }
    %>
    <%
            if (canadd || isAdministrator)
            {
    %>

    <p><a href="<%=deleteUrl%>">[Eliminar Entrada]</a></p>
    <%
            }
    %>
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
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?blog=" + java.net.URLEncoder.encode(post.getBlog().getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al blog de la comunidad</a></li>
    </ul>
</div>

