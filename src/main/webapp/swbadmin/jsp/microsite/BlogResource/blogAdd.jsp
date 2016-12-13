<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    dojo.require("dojox.layout.FloatingPane");
    dojo.require("dijit.form.Button");
    dojo.require("dijit.form.TextBox");

    dojo.require("dijit.Editor");
    dojo.require("dijit._editor.plugins.LinkDialog");
    dojo.require("dijit._editor.plugins.FontChoice");
    dojo.require("dijit._editor.plugins.TextColor");
    dojo.require("dojo.parser");    
    dojo.require("dojox.xml.parser");
</script>
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
            String cancelurl = paramRequest.getRenderUrl().toString();

%>
<div class="columnaIzquierda">
    <div class="adminTools">        
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>        
    </div>
    <form style="margin-left:10px; margin-right:10px" name="frmaddpost" id="frmaddpost" method="post" action="<%=paramRequest.getActionUrl()%>">
        <input type="hidden" name="act" value="<%=request.getParameter("act")%>">
        <input type="hidden" name="content" id="content" value="">
        <div>
            <fieldset><legend>Agregar entrada</legend>
                <div>
                    <p>
                        <br/><label for="title">Título:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><br/><input id="title" size="50" maxlength="50" name="title" value=""><br/><br/>
                        <label for="description">Descripción:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label><br/><textarea rows="10" cols="45" id="description" name="description"></textarea><br/><br/>
                        <label for="editor">Contenido de la entrada:&nbsp;&nbsp;&nbsp;</label><br/><br/>
                        <textarea id="editor" plugins="['undo', 'redo', 'cut', 'copy', 'paste','|','bold','italic','underline', 'strikethrough','forecolor', 'hilitecolor','|','insertUnorderedList','insertOrderedList','|','createLink','unlink','|','indent', 'outdent','justifyCenter', 'justifyFull', 'justifyLeft', 'justifyRight', 'delete', 'selectall']" dojoType="dijit.Editor" rows="5" cols="23" name="editor"></textarea>
                        <script type="text/javascript">
                            function validaForma()
                            {
                                var title = document.frmaddpost.title.value;
                                if(!title)
                                {
                                    alert('¡Debe ingresar el título de la entrada!');
                                    document.frmaddpost.title.focus();
                                    return;
                                }
                                var description = document.frmaddpost.description.value;
                                if(!description)
                                {
                                    alert('¡Debe ingresar la descripción de la entrada!');
                                    document.frmaddpost.description.focus();
                                    return;
                                }
                                content = dijit.byId('editor').getValue(false);
                                if(!content || content=='<br _moz_editor_bogus_node="TRUE" />' || content=='<br />')
                                {
                                    alert('¡Debe ingresar la entrada del post!');
                                    dijit.byId('editor').focus();
                                    return;
                                }
                                var msg='¿Estan los datos correctos de la entrada del blog?';
                                if(confirm(msg))
                                {
                                    document.frmaddpost.content.value=content;
                                    document.frmaddpost.submit();
                                }
                            }
                        </script>
                    </p>
                </div>
            </fieldset>
            <br/>
            <fieldset>
                <legend><strong>¿Quién puede ver esta entrada?</strong></legend>
                <ul class="options">
                    <%String chk = "checked=\"checked\"";%>
                    <li><label><input type="radio" checked class="radio" name="level" value="0" /> Cualquiera</label></li>
                    <li><label><input type="radio" class="radio" name="level" value="1" /> Sólo los miembros</label></li>
                            <%-- <li><label><input type="radio" class="radio" name="level" value="3" /> Sólo yo</label></li> --%>
                </ul>
            </fieldset>
            <br/>
        </div>
    </form>
    <br/>
    <br/>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>
    </div>
</div>

<div class="columnaCentro">

</div>