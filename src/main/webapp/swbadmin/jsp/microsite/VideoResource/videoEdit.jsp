<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            Member member = Member.getMember(user, wpage);
            String uri = request.getParameter("uri");
            if (uri == null || uri.equals(""))
            {
                response.sendError(404);
                return;
            }
            VideoElement rec = (VideoElement) SemanticObject.createSemanticObject(uri).createGenericInstance();
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
            String title = "";
            if (rec.getTitle() != null)
            {
                title = rec.getTitle();
            }
            String description = "";
            if (rec.getDescription() != null)
            {
                description = rec.getDescription();
            }
            String tags = "";
            if (rec.getTags() != null)
            {
                tags = rec.getTags();
            }

%>
<script type="text/javascript">
    function validaForma()
    {
        var foto = document.frmeditvideo.video_code.value;
        if(!foto)
        {
            alert('¡Debe ingresar el código de youtube!');
            document.frmaddfoto.foto.focus();
            return;
        }
        var title = document.frmeditvideo.video_title.value;
        if(!title)
        {
            alert('¡Debe ingresar el título del video!');
            document.frmaddfoto.description.focus();
            return;
        }
        var description = document.frmeditvideo.video_description.value;
        if(!description)
        {
            alert('¡Debe ingresar la description del video!');
            document.frmaddfoto.description.focus();
            return;
        }
        document.frmeditvideo.submit();
    }
</script>
<%
            String cancelurl = paramRequest.getRenderUrl().toString();
%>
<div class="columnaIzquierda">
    <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>
    </div>
    <form method="post" name="frmeditvideo" action="<%=paramRequest.getActionUrl()%>">
        <div>
            <h3>Añádele el título, descripción y otra información al video que agregaste.</h3>
            <!--
                    <p class="last-child"><strong><a href="http://webbuilder.ning.com/video/video/show?id=2034909%3AVideo%3A102">&#171; Cancelar y volver al video</a></strong></p>
            -->
        </div>
        <div>
            <fieldset><legend></legend>
                <div>
                    <p>
                        <img  src="<%=rec.getPreview()%>" alt="" width="218"/>
                    </p>
                </div>
                <div>
                    <div>
                        <p>
                            <label for="video_code">Código youTube&nbsp;<em>*</em></label><br/>
                            <textarea id="video_code" rows="10" cols="60" name="video_code"><%=rec.getCode()%></textarea>
                        </p>
                        <p>
                            <label for="video_title">Título:</label><br/>
                            <input id="video_title" style="width: 98%;" type="text" class="textfield" size="25" name="video_title" maxlength="200" value="<%=title%>" />
                        </p>
                        <p>
                            <label for="video_description">Descripción</label><br/>
                            <textarea id="video_description" style="width: 98%" rows="5" cols="23" name="video_description"><%=description%></textarea>
                        </p>
                        <p>
                            <label for="video_tags">Etiquetas:</label><br />
                            <input id="video_tags" type="text" style="width: 90%;" class="textfield tags" size="22" name="video_tags" value="<%=tags%>" maxlength="2000" />
                        </p>
                    </div>
                </div>
                <div>
                    <div>
                        <fieldset>
                            <legend><strong>¿Quién puede ver este video?</strong></legend>

                            <%String chk = "checked=\"checked\"";%>
                            <label><input type="radio" class="radio" name="level" value="0" <%if (rec.getVisibility() == 0)
            {
                out.println(chk);
            }%>/> Cualquiera</label><br/>
                            <label><input type="radio" class="radio" name="level" value="1" <%if (rec.getVisibility() == 1)
            {
                out.println(chk);
            }%>/> Sólo los miembros</label><br/>
                                <%--<label><input type="radio" class="radio" name="level" value="3" <%if (rec.getVisibility() == 3)
                                {
                                    out.println(chk);
                                }%>/> Sólo yo</label> --%>

                        </fieldset>
                    </div>
                </div>
            </fieldset>            
        </div>
        <input type="hidden" name="uri" value="<%=rec.getURI()%>"/>
        <input type="hidden" name="act" value="edit"/>
    </form>
         <div class="adminTools">
        <a class="adminTool" onclick="validaForma()" href="#">Guardar</a>
        <a class="adminTool" href="<%=cancelurl%>">Cancelar</a>
    </div>
</div>
<div class="columnaCentro"></div>