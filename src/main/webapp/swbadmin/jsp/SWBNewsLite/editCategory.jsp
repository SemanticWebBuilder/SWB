<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    SWBResourceURL action=paramRequest.getActionUrl();
    Category category=(Category)request.getAttribute("category");
    String title=category.getTitle();
    String description=category.getDescription();

    if(title==null)
    {
        title="";
    }
    if(description==null)
    {
        description="";
    }
%>
<script type="text/javascript">
    function validaForma()
    {
        var title = document.frmaddNew.title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título de la categoria!');
            document.frmaddNew.description.focus();
            return;
        }
        var description = document.frmaddNew.description.value;
        if(!description)
        {
            alert('¡Debe ingresar la descripción de la categoria!');
            document.frmaddNew.description.focus();
            return;
        }
        document.frmaddNew.submit();
    }
</script>
<div class="columnaIzquierda">
 <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
<form name="frmaddNew" id="frmaddNew" method="post" action="<%=action%>">
    <input type="hidden" name="act" value="editCategory"/>
    <input type="hidden" name="uri" value="<%=category.getURI()%>"/>
    <fieldset>
        <legend>Editar Categoria</legend>

    <p>
        <label for="title">Título:&nbsp;</label><br />
        <input id="title" value="<%=title%>" type="text" name="title" maxlength="50" size="45" />
    </p>
    <p>
        <label for="description">Descripción:&nbsp;</label><br />
        <textarea id="description" cols="45" rows="3" name="description"><%=description%></textarea>
    </p>

    </fieldset>
</form>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
</div>