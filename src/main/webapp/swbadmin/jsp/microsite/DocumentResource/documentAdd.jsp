<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    User user = paramRequest.getUser();
    WebPage wpage = paramRequest.getWebPage();
    Member member = Member.getMember(user, wpage);
    if (!member.canAdd())
    {
        return;
    }
    String addElURL = paramRequest.getActionUrl().setParameter("act", "add").toString();
%>

<script type="text/javascript">
    function validaForma()
    {
        var docto = document.frmadddoc.title.value;
        if(!docto)
        {
            alert('¡Debe ingresar el archivo del documento!');
            document.frmadddoc.docto.focus();
            return;
        }
        var title = document.frmadddoc.title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título del documento!');
            document.frmadddoc.description.focus();
            return;
        }
        var description = document.frmadddoc.description.value;
        if(!description)
        {
            alert('¡Debe ingresar la description del documento!');
            document.frmadddoc.description.focus();
            return;
        }
        document.frmadddoc.submit();
    }
</script>
<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
    <form name="frmadddoc" id="frmadddoc" enctype="multipart/form-data" method="post" action="<%= addElURL%>">
        <div>
            <fieldset>
                <legend>Agregar documento</legend>
                <div>
                    <p>
                        <label for="docto">Archivo:&nbsp;</label><br />
                        <input id="docto" type="file" name="docto" size="45" />
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
                <legend>¿Quién puede ver este documento?</legend>
                <div>
                    <p>
                        <label for="level"><input type="radio" name="level" value="0" checked="checked" />&nbsp;Cualquiera</label>
                    </p>
                    <p>
                        <label for="level"><input type="radio" name="level" value="1" />&nbsp;Sólo los miembros</label>
                    </p>
                    <%-- <p>
                        <label for="level"><input type="radio" name="level" value="3" />&nbsp;Sólo yo</label>
                    </p> --%>
                </div>
            </fieldset>
        </div>
    </form>
</div>
<div class="columnaCentro">

</div>