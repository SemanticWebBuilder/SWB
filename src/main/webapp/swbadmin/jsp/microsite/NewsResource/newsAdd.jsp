<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
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
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.Button");
    dojo.require("dojo.parser");

    function validaForma()
    {
        var foto = document.frmaaddnews.foto.value;
        if(!foto)
        {
            alert('¡Debe ingresar la imagen de la noticia!');
            document.frmaaddnews.foto.focus();
            return;
        }
        var new_title = document.frmaaddnews.new_title.value;
        if(!new_title)
        {
            alert('¡Debe ingresar el título de la noticia!');
            document.frmaaddnews.new_title.focus();
            return;
        }
        var new_author = document.frmaaddnews.new_author.value;
        if(!new_author)
        {
            alert('¡Debe ingresar el autor de la noticia!');
            document.frmaaddnews.new_author.focus();
            return;
        }
        var new_abstract = document.frmaaddnews.new_abstract.value;
        if(!new_abstract)
        {
            alert('¡Debe ingresar el resumen de la noticia!');
            document.frmaaddnews.new_abstract.focus();
            return;
        }
        var new_fulltext = document.frmaaddnews.new_fulltext.value;
        if(!new_fulltext)
        {
            alert('¡Debe ingresar el texto de la noticia!');
            document.frmaaddnews.new_fulltext.focus();
            return;
        }
        var new_citation = document.frmaaddnews.new_citation.value;
        if(!new_citation)
        {
            alert('¡Debe ingresar la fuente de la noticia!');
            document.frmaaddnews.new_citation.focus();
            return;
        }
        document.frmaaddnews.submit();
    }
</script>

<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=paramRequest.getRenderUrl()%>">Cancelar</a>
    </div>
    <p><span class="tituloRojo">NOTA: </span>Se recomienda subir imagenes de 150 x 150 pixeles.</p>
    <form name="frmaaddnews" id="frmaaddnews" class="swbform" enctype="multipart/form-data" method="post" action="<%=paramRequest.getActionUrl()%>">
        <div>
            <fieldset>
                <legend>Agregar noticia</legend>
                <div>
                    <p>
                        <label for="new_image">Imagen de la noticia:&nbsp;</label><br />
                        <input type="file" id="foto" name="foto" size="45" />
                    </p>
                    <p>
                        <label for="new_title">Título de la noticia:&nbsp;</label><br />
                        <input type="text" id="new_title" name="new_title" maxlength="70" size="60" />
                    </p>
                    <p>
                        <label for="new_author">Autor de la noticia:&nbsp;</label><br />
                        <input type="text" id="new_author" name="new_author" maxlength="50" size="60" />
                    </p>
                    <p>
                        <label for="new_abstract">Resumen de la noticia:&nbsp;</label><br />
                        <textarea id="new_abstract" name="new_abstract" cols="45" rows="2"></textarea>
                    </p>
                    <p>
                        <label for="new_fulltext">Texto completo:&nbsp;</label><br />
                        <textarea id="new_fulltext" name="new_fulltext" cols="45" rows="6"></textarea>
                    </p>
                    <p>
                        <label for="new_citation">Fuente:&nbsp;</label><br />
                        <input type="text" id="new_citation" name="new_citation" maxlength="50" size="60" />
                    </p>
                    <p>
                        <label for="new_tags">Etiquetas:&nbsp;</label><br />
                        <input type="text" id="new_tags" name="new_tags" maxlength="50" size="60" />
                    </p>
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