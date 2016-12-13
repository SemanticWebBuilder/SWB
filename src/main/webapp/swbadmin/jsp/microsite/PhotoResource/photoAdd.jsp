<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);
            if (!member.canAdd())
            {
                response.sendError(404);
                return;
            }
%>

<script type="text/javascript">
    function validaForma()
    {
        var foto = document.frmaddfoto.title.value;
        if(!foto)
        {
            alert('¡Debe ingresar el archivo de la foto!');
            document.frmaddfoto.foto.focus();
            return;
        }
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
<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
    <p><span class="tituloRojo">NOTA: </span>Se recomienda subir imagenes de 150 x 150 pixeles.</p>
    <form name="frmaddfoto" id="frmaddfoto" enctype="multipart/form-data" method="post" action="<%=paramRequest.getActionUrl()%>">
        <div>
            <fieldset>
                <legend>Agregar foto</legend>
                <div>
                    <p>
                        <label for="foto">Archivo:&nbsp;</label><br />
                        <input id="foto" type="file" name="foto" size="45" />
                    </p>
                    <p>
                        <label for="title">Título:&nbsp;</label><br />
                        <input id="title" type="text" name="title" maxlength="50" size="45" />
                    </p>
                    <p>
                        <label for="description">Descripción</label><br />
                        <textarea id="description" cols="45" rows="3" name="description"></textarea>
                    </p>
                    <p>
                        <label for="tags">Etiquetas:&nbsp;</label><br />
                        <input id="tags" type="text" name="tags" maxlength="50" size="45" />
                    </p>
                </div>
            </fieldset>
            <fieldset>
                <legend>¿Quién puede ver esta foto?</legend>
                <div>
                    <p>
                        <label for="level"><input type="radio" name="level" value="0" checked="checked" />&nbsp;Cualquiera</label>
                    </p>
                    <p>
                        <label for="level"><input type="radio" name="level" value="1" />&nbsp;Sólo los miembros</label>
                    </p>
                    <%--<p>
                        <label for="level"><input type="radio" name="level" value="3" />&nbsp;Sólo yo</label>
                    </p> --%>
                </div>
            </fieldset>

        </div>
        <input type="hidden" name="act" value="add"/>
    </form>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
</div>
<div class="columnaCentro">

</div>