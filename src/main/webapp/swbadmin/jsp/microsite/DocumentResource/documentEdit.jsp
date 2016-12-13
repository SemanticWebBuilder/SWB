<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();
    Member member=Member.getMember(user,wpage);
%>
<%
    String uri=request.getParameter("uri");
    DocumentElement rec= (DocumentElement)SemanticObject.createSemanticObject(uri).createGenericInstance();
    if(rec==null)
    {
%>
        Error: Elemento no encontrado...
<%
        return;
    }
    if(!rec.canModify(member))
    {
        return;
    }
    String editElURL = paramRequest.getActionUrl().setParameter("act", "edit").setParameter("uri", rec.getURI()).toString();
%>
<script type="text/javascript">
    function validaForma()
    {      
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

<br />
<div id="panorama">
<form name="frmadddoc" id="frmadddoc" enctype="multipart/form-data" method="post" action="<%= editElURL%>">
    <div>
        <fieldset>
            <legend>Editar documento</legend>
            <div>
                <p>
                    <label for="docto">Archivo:&nbsp;</label><br />
                    <input id="docto" type="file" size="22" name="docto" size="60" />
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
            <legend>¿Quién puede ver este documento?</legend>
            <%String chk = "checked=\"checked\"";%>
            <div>
                <p>
                    <label for="level"><input type="radio" name="level" value="0" <%if(rec.getVisibility()==0)out.println(chk);%> />&nbsp;Cualquiera</label>
                </p>
                <p>
                    <label for="level"><input type="radio" name="level" value="1" <%if(rec.getVisibility()==1)out.println(chk);%> />&nbsp;Sólo los miembros</label>
                </p>
<%--                <p>
                    <label for="level"><input type="radio" name="level" value="3" <%if(rec.getVisibility()==3)out.println(chk);%> />&nbsp;Sólo yo</label>
                </p> --%>
            </div>
        </fieldset>
        <fieldset>
            <legend></legend>
            <div>
            <p>
                <div class="editarInfo"><p><a onclick="validaForma()" href="#">Guardar</a></p></div>
                <div class="editarInfo"><p><a href="<%=paramRequest.getRenderUrl()%>">Cancelar</a></p></div>
            </p>
            </div>
        </fieldset>
    </div>
</form>
</div>