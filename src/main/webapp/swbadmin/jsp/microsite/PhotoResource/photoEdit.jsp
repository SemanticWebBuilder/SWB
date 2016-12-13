<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);
%>
<%
            String uri = request.getParameter("uri");
            if (uri == null || uri.equals(""))
            {
                response.sendError(404);
                return;
            }
            PhotoElement rec = (PhotoElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
            if (rec == null)
            {
                response.sendError(404);
                return;
            }
            if (!rec.canModify(member))
            {
                response.sendError(404);
                return;
            }
%>
<script type="text/javascript">
    function validaForma()
    {
        var title = document.frmaddfoto.title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título de la foto!');
            document.frmaddfoto.description.focus();
            return;
        }
        var description = document.frmaddfoto.description.value;
        if(!description)
        {
            alert('¡Debe ingresar la description de la foto!');
            document.frmaddfoto.description.focus();
            return;
        }
        document.frmaddfoto.submit();
    }
</script>

<br />
<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
    <p><span class="tituloRojo">NOTA: </span>Se recomienda subir imagenes de 150 x 150 pixeles.</p>
    <form name="frmaddfoto" id="frmaddfoto" enctype="multipart/form-data" method="post" action="<%=paramRequest.getActionUrl()%>">
        <div>
            <fieldset>
                <legend>Editar foto</legend>
                <div>
                    <p>
                        <label for="foto">Archivo:&nbsp;</label><br />
                        <input id="foto" type="file" size="22" name="foto" size="60" />
                    </p>
                    <p>
                        <label for="title">Título:&nbsp;</label><br />
                        <input id="title" type="text" size="25" name="title" maxlength="50" value="<%= rec.getTitle()%>" size="60" />
                    </p>
                    <p>
                        <label for="description">Descripción</label><br />
                        <textarea id="description" cols="60" rows="5" name="description"><%= rec.getDescription()%></textarea>
                    </p>
                    <p>
                        <label for="tags">Etiquetas:&nbsp;</label><br />
                        <input id="tags" type="text" size="22" name="tags" maxlength="50" value="<%= rec.getTags()%>" size="60" />
                    </p>
                </div>
            </fieldset>
            <fieldset>
                <legend>¿Quién puede ver este evento?</legend>
                <%String chk = "checked=\"checked\"";%>
                <div>
                    <p>
                        <label for="level"><input type="radio" name="level" value="0" <%if (rec.getVisibility() == 0)
            {
                out.println(chk);
            }%> />&nbsp;Cualquiera</label>
                    </p>
                    <p>
                        <label for="level"><input type="radio" name="level" value="1" <%if (rec.getVisibility() == 1)
            {
                out.println(chk);
            }%> />&nbsp;Sólo los miembros</label>
                    </p>
                    <%-- <p>
                        <label for="level"><input type="radio" name="level" value="3" <%if(rec.getVisibility()==3)out.println(chk);%> />&nbsp;Sólo yo</label>
                    </p> --%>
                </div>
            </fieldset>            
        </div>
        <input type="hidden" name="uri" value="<%=rec.getURI()%>"/>
        <input type="hidden" name="act" value="edit"/>
    </form>
        <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
</div>
    <div class="columnaCentro">

</div>