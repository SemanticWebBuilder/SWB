<%-- 
    Document   : swbForoEdit
    Created on : 17/01/2014, 11:40:06 AM
    Author     : carlos.alvarez
--%>

<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.util.CaptchaUtil"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<script src="<%= SWBPortal.getContextPath() %>/swbadmin/js/tinymce/tinymce.min.js"></script>
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/jsp/forum/css/swbforum.css">
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/bootstrap/bootstrap.min.css">
<%
    SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
    String threadUri = request.getParameter("threadUri") != null ? request.getParameter("threadUri") : "";
    org.semanticwb.portal.resources.sem.forum.Thread thread = (org.semanticwb.portal.resources.sem.forum.Thread) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(threadUri);
    WebSite model = paramRequest.getWebPage().getWebSite();
    SWBResourceURL urlAction = paramRequest.getActionUrl().setAction("addThread");
    SWBResourceURL backUrl = paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW);
    SWBFormMgr forMgr = new SWBFormMgr(org.semanticwb.portal.resources.sem.forum.Thread.frm_Thread, model.getSemanticObject(), SWBFormMgr.MODE_CREATE);
    String iconClass = "fa fa-plus";
    Boolean isCaptcha = request.getAttribute("isCaptcha") != null ? Boolean.parseBoolean(request.getAttribute("isCaptcha").toString()) : false;
    String mode = SWBFormMgr.MODE_CREATE;
    String lblAction = paramRequest.getLocaleString("newthread");

    if (thread != null) {
        iconClass = "fa fa-edit";
        forMgr = new SWBFormMgr(thread.getSemanticObject(), null, SWBFormMgr.MODE_EDIT);
        mode = SWBFormMgr.MODE_EDIT;
        urlAction.setAction("editThread");
        urlAction.setParameter("threadUri", thread.getURI());
        lblAction = paramRequest.getLocaleString("edit") + " " + paramRequest.getLocaleString("thread");
        backUrl.setAction("viewPost");
        backUrl.setParameter("threadUri", threadUri);
    }
    String flag = request.getParameter("flag") != null ? request.getParameter("flag").toString() : "";
    String language = paramRequest.getUser().getLanguage().equalsIgnoreCase("es") ? "es_MX" : paramRequest.getUser().getLanguage();
%>
<script>
    tinymce.init({
        selector:'textarea',
	menubar: true,
        language: '<%=language%>',
	plugins: [
            " anchor autolink colorpicker fullscreen ",
            " lists link noneditable preview",
            " searchreplace table textcolor visualblocks wordcount"
	],
        toolbar: 'undo redo | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist ',
    });
</script>
<div class="container">
    <div id="swbBlog">
        <div class="swbBlog-head">
            <span><%=lblAction%></span>
        </div>
	<form class="form-horizontal" id="formSaveThread" method="post" action="<%=urlAction%>">
            <% if (!flag.equals("")) { %>
                <div class="alert alert-warning alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                </div>
            <% }
            out.print(forMgr.getFormHiddens());%>
            <div class="card card-new">
                <div class="card-body">
                    <div class="card-new-title">
                        <label for="<%=org.semanticwb.portal.resources.sem.forum.Thread.swb_title.getName()%>"><%=SWBUtils.TEXT.parseHTML(forMgr.renderLabel(request, org.semanticwb.portal.resources.sem.forum.Thread.swb_title, mode))%></label>
			<%
                            String inputTitle = forMgr.renderElement(request, org.semanticwb.portal.resources.sem.forum.Thread.swb_title, mode);
                            inputTitle = inputTitle.replaceFirst("/>", "required class=\"form-control\" id=\"" + org.semanticwb.portal.resources.sem.forum.Thread.swb_title.getName() + "\">");
                            inputTitle = inputTitle.replace(inputTitle.substring(inputTitle.indexOf("style"), (inputTitle.indexOf("px;\"") + 4)), "");
                            out.println(inputTitle);
                         %>
                    </div>
                    <%
			String inputMessage = forMgr.renderElement(request, org.semanticwb.portal.resources.sem.forum.Thread.frm_thBody, mode);
                        inputMessage = inputMessage.replaceFirst(">", " required class=\"form-control\" rows=\"6\">");
                        inputMessage = inputMessage.replace(inputMessage.substring(inputMessage.indexOf("style"), (inputMessage.indexOf("px;\"") + 4)), "");
                        //out.println(inputMessage);
			out.println("<textarea name='thBody' id='thBody'></textarea>");
                    %>
                </div>
		<% if (isCaptcha) { %>
                    <div class="form-group" id="divcmnt_seccode">
			<label for="" class="col-lg-3 control-label"><%="Captcha *:"%></label>
                        <div class="col-lg-4">
                            <%="<img src=\"" + SWBPlatform.getContextPath() + "/swbadmin/jsp/securecode.jsp\" alt=\"\" id=\"imgseccode\" width=\"155\" height=\"65\" />"%>
                        </div>
                        <div class="col-lg-5">
                            <%="<input class=\"form-control\" required type=\"text\" name=\"cmnt_seccode\" value=\"\"/>"%>
                        </div>
                    </div>
                <% } %>
                <div class="card-footer">
                    <button type="button" class="btn btn-cancel" onclick="window.location.replace('<%=backUrl%>')"><%=paramRequest.getLocaleString("cancel")%></button>
                    <button type="submit" class="btn" id="btnSaveThread"><%=paramRequest.getLocaleString("send")%></button>
                </div>
            </div>
	</form>
    </div>
</div>

<script>
    document.getElementById("title").focus();
    $('#btnSaveThread').click(function() {
        var $inputs = $('#formSaveThread :input');
        var cont = 0;
        $inputs.each(function() {
            if (this.required) {
                var diverror = $('#div' + this.name);
                if ($(this).val().length === 0) {
                    diverror.addClass('has-error');
                    cont++;
                } else {
                    diverror.removeClass('has-error');
                }
            }
        });
        if (cont === 0) {
            var forma = document.getElementById('formSaveThread');
            forma.submit();
        }
        return false;
    });
</script>