<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.semanticwb.platform.SemanticObject,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

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
            Blog blog = (Blog) request.getAttribute("blog");
            String cancelurl = paramRequest.getRenderUrl().toString();
%>


<%
            if ("editpost".equals(request.getParameter("mode")))
            {
                String uri = request.getParameter("uri");
                if (uri == null || uri.equals(""))
                {
                    response.sendError(404);
                    return;
                }
                if (uri != null)
                {
                    PostElement post = (PostElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
                    if (post == null || !post.canModify(member))
                    {
                        response.sendError(404);
                        return;
                    }
%>
<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>
    </div>
    <form style="margin-left:10px; margin-right:10px" name="frmaddpost" id="frmaddpost" method="post" action="<%=paramRequest.getActionUrl()%>">
        <input type="hidden" name="act" value="edit">
        <input type="hidden" name="mode" value="editpost">
        <input type="hidden" name="uri" value="<%=request.getParameter("uri")%>">
        <input type="hidden" name="content" id="content" value="">
        <div>
            <fieldset><legend>Editar entrada</legend>
                <div>
                    <p>
                        <br/><label for="title">Título:&nbsp;&nbsp;&nbsp;&nbsp;</label><br/><input size="50" id="title" name="title" value="<%=post.getTitle()%>" maxlength="50"><br/><br/>
                        <label for="description">Descripción:&nbsp;&nbsp;&nbsp;&nbsp;</label><br/>
                        <textarea size="50" rows="10" cols="45" id="description" name="description" maxlength="255" ><%=post.getDescription()%></textarea><br/><br/>
                        <label for="editor">Contenido de entrada:</label><br/><br/>
                        <textarea plugins="['undo', 'redo', 'cut', 'copy', 'paste','|','bold','italic','underline', 'strikethrough','forecolor', 'hilitecolor','|','insertUnorderedList','insertOrderedList','|','createLink','unlink','|','indent', 'outdent','justifyCenter', 'justifyFull', 'justifyLeft', 'justifyRight', 'delete', 'selectall']" dojoType="dijit.Editor" id="editor" rows="5" cols="23" name="editor"><%=post.getContent()%></textarea>
                    </p>
                </div>
            </fieldset>
            <br/>
            <fieldset>
                <legend><strong>¿Quién puede ver esta entrada?</strong></legend>
                <ul class="options">
                    <%String chk = "checked=\"checked\"";%>
                    <li><label><input type="radio" class="radio" name="level" value="0" <%if (post.getVisibility() == 0)
      {
          out.println(chk);
                    }%>/> Cualquiera</label></li>
                    <li><label><input type="radio" class="radio" name="level" value="1" <%if (post.getVisibility() == 1)
  {
      out.println(chk);
                    }%>/> Sólo los miembros</label></li>
                            <%--<li><label><input type="radio" class="radio" name="level" value="3"
                                              <%if (post.getVisibility() == 3)
                        {
                            out.println(chk);
                    }%>/> Sólo yo</label></li> --%>
                </ul>
            </fieldset>
            <br/>
            <%-- <div class="editarInfo"><p><a onclick="validaForma()" href="#">Guardar</a></p></div>
            <div class="editarInfo"><p><a href="<%=paramRequest.getRenderUrl()%>">Cancelar</a></p></div>                     --%>
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
        </div>
        <input type="hidden" name="act" value="add"/>
    </form>
</div>
<div class="columnaCentro">

</div>
<%
                }
            }
            else if ("editblog".equals(request.getParameter("mode")))
            {
                if (member.getAccessLevel() != Member.LEVEL_OWNER)
                {
                    return;
                }
%>
<div class="columnaIzquierda">
    <div class="adminTools">

        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>

    </div>
    <form style="margin-left:10px; margin-right:10px" name="frmaddpost" id="frmaddpost" method="post" action="<%=paramRequest.getActionUrl()%>">
        <input type="hidden" name="act" value="edit">
        <input type="hidden" name="mode" value="editblog">
        <div>
            <h3>Editar título y descripción del blog</h3>
        </div>
        <div>

            <fieldset><legend></legend>
                <div>
                    <p>
                        <label for="title">Título del blog:</label><br/>
                        <input id="title" name="title" value="<%=blog.getTitle()%>" size="40" maxlength="50"><br/><br/>
                        <label for="description">Descripción del blog:</label><br/>
                        <textarea id="description" rows="10" cols="45"  name="description"><%=blog.getDescription()%></textarea>
                    </p>
                </div>
            </fieldset>
            <br/>
            <%-- <div class="editarInfo"><p><a onclick="validaForma()" href="<%=%>">Guardar</a></p></div>
            <div class="editarInfo"><p><a class="button" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a></p></div> --%>
            <script type="text/javascript">
                function validaForma()
                {
                    var title = frmaddpost.title.value;
                    if(!title)
                    {
                        alert('Debe ingresar el título de la entrada');
                        return;
                    }
                    var description = frmaddpost.description.value;
                    if(!description)
                    {
                        alert('Debe ingresar la descripción de la entrada');
                        return;
                    }
                    var msg='¿Estan los datos correctos?';
                    if(confirm(msg))
                    {
                        dojo.byId('frmaddpost').submit();
                    }
                }
            </script>
        </div>

    </form>
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>
    </div>
</div>

<div class="columnaCentro">

</div>
<%
            }
%>

