<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.lib.*,java.text.*,org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);

            String lang = user.getLanguage();

            String uri = request.getParameter("uri");
            DocumentElement doc = (DocumentElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
            java.text.SimpleDateFormat dateFormat = new java.text.SimpleDateFormat("dd-MMM-yyyy");

            DecimalFormat df = new DecimalFormat("#0.0#");
            String rank = df.format(doc.getRank());
            if (doc != null && doc.canView(member))
            {
                doc.incViews();  //Incrementar apariciones
%>


<div class="columnaIzquierda">
    <p>
        <a href="/swbadmin/jsp/microsite/DocumentResource/displayDoc.jsp?uri=<%=java.net.URLEncoder.encode(doc.getURI())%>" target="new"><%= doc.getTitle()%></a>
    </p>
</div>
<%
            }

            SWBResponse res = new SWBResponse(response);
            doc.renderGenericElements(request, res, paramRequest);
            out.write(res.toString());
            String postAuthor = "Usuario dado de baja";
            if (doc.getCreator() != null)
            {
                postAuthor = doc.getCreator().getFirstName();
            }
%>

<div class="columnaCentro">
    <h2 class="blogTitle">
        <a href="/swbadmin/jsp/microsite/DocumentResource/displayDoc.jsp?uri=<%=java.net.URLEncoder.encode(doc.getURI())%>" target="new"><%= doc.getTitle()%></a>
    </h2><br/>
    <p><%= doc.getDescription()%></p>
    <p>Autor: <%= postAuthor%></p>
    <p>Creado el: <%=dateFormat.format(doc.getCreated())%></p>
    <p><%= doc.getViews()%> vistas</p>
    <p>Calificación: <%=rank%></p>
    <p><a href="<%=paramRequest.getRenderUrl()%>">[Ver todos los documentos]</a></p>
    <%if (doc.canModify(member))
            {%>
    <p><a href="<%=paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", doc.getURI())%>">[Editar información]</a></p>
    <%}%>
    <%if (doc.canModify(member))
            {%>
    <p><a href="<%=paramRequest.getActionUrl().setParameter("act", "remove").setParameter("uri", doc.getURI())%>">[Eliminar]</a></p>
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
            String pageUri = "/swbadmin/jsp/microsite/rss/rss.jsp?photo=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de fotos de la comunidad</a></li>
    </ul>

</div>