<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.resources.sem.newslite.*,java.util.*,java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    dojo.require("dijit.Editor");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.Button");
    dojo.require("dojo.parser");
    function validaForma()
    {
        var foto = document.frmaddNew.filename.value;
        if(!foto)
        {
            alert('¡Debe ingresar la imagen de la noticia!');
            document.frmaddNew.filename.focus();
            return;
        }
        var title = document.frmaddNew.title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título de la noticia!');
            document.frmaddNew.description.focus();
            return;
        }
        var description = document.frmaddNew.description.value;
        if(!description)
        {
            alert('¡Debe ingresar el resumen de la noticia!');
            document.frmaddNew.description.focus();
            return;
        }
        content = dijit.byId('editor').getValue(false);
        if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
        {
            alert('¡Debe ingresar el cuerpo de la noticia!');
            dijit.byId('editor').focus();
            return;
        }
        var author = document.frmaddNew.author.value;
        if(!author)
        {
            var source = document.frmaddNew.source.value;
            if(!source)
            {
                alert('¡Debe ingresar la fuente o el autor de la noticia!');
                document.frmaddNew.source.focus();
                return;
            }
        }
        var event_endDate = dijit.byId('new_endDate').getValue(false);
        if(!event_endDate)
        {
            alert('¡Debe ingresar la fecha de expiración de la noticia!');
            dijit.byId('new_endDate').focus();
            return;
        }
        document.frmaddNew.body.value=content;
        document.frmaddNew.submit();
    }
    
</script>
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    SWBResourceURL action=paramRequest.getActionUrl();
    String uri=paramRequest.getResourceBase().getAttribute("category");
    Category ocategory=null;
    try
    {
        ocategory = (Category) SemanticObject.createSemanticObject(uri).createGenericInstance();
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }

%>
<div class="columnaIzquierda">
 <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
<form name="frmaddNew" id="frmaddNew" enctype="multipart/form-data" method="post" action="<%=action%>">
    <input type="hidden" name="act" value="add"/>
    <input type="hidden" name="body" id="body" value="">
    <fieldset>
        <legend>Agregar Noticia</legend>

        <%
            if(paramRequest.getResourceBase().getAttribute("category")==null || ocategory==null)
            {
                %>
                <p>
        <label for="title">Categoria:&nbsp;</label><br />
                        <select name="category">
                    <%
                        Iterator<Category> categories=Category.ClassMgr.listCategories(paramRequest.getWebPage().getWebSite());
                        while(categories.hasNext())
                        {
                            Category category=categories.next();
                            %>
                            <option value="<%=category.getURI()%>"><%=category.getTitle()%></option>
                            <%
                        }
                    %>
                </select>

    </p>
                <%
            }
        else
            {
            
            String categoria=ocategory.getTitle();

            %>
            <p>
                Categoria: <%=categoria%>
                <input type="hidden" name="category" id="category" value="<%=ocategory.getURI()%>">
            </p>
            <%
            }
        %>
    <p>
        <label for="foto">Imagen de la noticia:&nbsp;</label><br />
        <input id="filename" type="file" name="filename" size="45" />
    </p>
    <p>
        <label for="title">Título:&nbsp;</label><br />
        <input id="title" type="text" name="title" maxlength="80" size="60" />
    </p>
    <p>
        <label for="description">Resumen:&nbsp;</label><br />
        <textarea id="description" cols="45" rows="3" name="description"></textarea>
    </p>

    <p>
        <label for="event_endDate">Fecha de expiración:&nbsp;</label><br />
        <input dojoType="dijit.form.DateTextBox" type="text" id="new_endDate" name="new_endDate" constraints="{datePattern:'dd/MM/yyyy'}"/>
    </p>
    <p>
        <label for="description">Cuerpo de la noticia:&nbsp;</label><br />
        <textarea plugins="['undo', 'redo', 'cut', 'copy', 'paste','|','bold','italic','underline', 'strikethrough','forecolor', 'hilitecolor','|','insertUnorderedList','insertOrderedList','|','createLink','unlink','|','indent', 'outdent','justifyCenter', 'justifyFull', 'justifyLeft', 'justifyRight', 'delete', 'selectall']" dojoType="dijit.Editor" id="editor" rows="5" cols="10" name="editor"></textarea>
    </p>
    <p>
        <label for="author">Author de la noticia:&nbsp;</label><br />
        <input id="author" type="text" name="author" maxlength="50" size="45" />
    </p>
     <p>
        <label for="author">Fuente de la noticia:&nbsp;</label><br />
        <input id="source" type="text" name="source" maxlength="50" size="45" />
    </p>
    
    </fieldset>
</form>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_ADMIN)%>">Cancelar</a>
    </div>
</div>