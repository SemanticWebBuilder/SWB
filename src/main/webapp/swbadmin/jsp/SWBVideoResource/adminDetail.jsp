<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.lib.*,org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.video.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            
            
            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");
%>
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

            String uri = request.getParameter("uri");
            VideoElement rec = (VideoElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
            if (rec == null)
            {
                response.sendError(404);
                return;
            }
            //rec.incViews();                             //Incrementar apariciones
            if (rec != null)
            {
                //String rank = df.format(rec.getRank());
                String title = "Sin título";
                if (rec.getTitle() != null)
                {
                    title = rec.getTitle().replace("'", "\\'");
                }
                String description = "Sin descripción";
                if (rec.getDescription() != null)
                {
                    description = rec.getDescription().replace("'", "\\'");
                }
                String tags = "Sin etiquetas";
                if (rec.getTags() != null)
                {
                    tags = rec.getTags().replace("'", "\\'");
                }
                String code="Video no definido";
                if(rec.getVideoCode()!=null)
                    {
                    code=rec.getVideoCode().replaceAll("&", "&amp;").replace("'", "\\'");
                    //code=rec.getVideoCode();
                    }
%>
<div class="columnaIzquierda">    
    <br/>
    <script type="text/javascript">
            <!--
            document.write('<%=code%>');
            -->
        </script>

    <br/>
    <%
                SWBResponse res = new SWBResponse(response);
                //rec.renderGenericElements(request, res, paramRequest);
                out.write(res.toString());
    %>
</div>
<div class="columnaCentro">
    <h2 class="blogTitle">
    <script type="text/javascript">
            <!--
            document.write('<%=title%>');
            -->
        </script></h2><br/>
    <p>
    <script type="text/javascript">
            <!--
            document.write('<%=description%>');
            -->
        </script></p>
    <p>Creado el: <%=dateFormat.format(rec.getCreated())%></p>
    <p>Etiquetas: <script type="text/javascript">
            <!--
            document.write('<%=tags%>');
            -->
        </script></p>
    <p><%=rec.getViews()%> vistas</p>
    <!--<p>Calificación: <//=rank></p>-->
    <p><a href="<%=paramRequest.getRenderUrl()%>">[Ver todos los videos]</a></p>    
    <p><a href="<%=paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", rec.getURI())%>">[Editar Información]</a></p>
    <p><a href="<%=paramRequest.getActionUrl().setParameter("act", "remove").setParameter("uri", rec.getURI())%>">[Eliminar]</a></p>

    
</div>
<%
            }
%>