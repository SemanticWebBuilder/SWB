<%-- 
    Document   : swbForoPostEdit
    Created on : 20/01/2014, 11:32:34 AM
    Author     : carlos.alvarez
--%>

<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.Post"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.WebSite"%>
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
    String postUri = request.getParameter("postUri") != null ? request.getParameter("postUri") : "";
    org.semanticwb.portal.resources.sem.forum.Post post = (org.semanticwb.portal.resources.sem.forum.Post) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(postUri);
    SWBResourceURL urlAction = paramRequest.getActionUrl().setAction("editPost");
    urlAction.setParameter("threadUri", threadUri);
    urlAction.setParameter("postUri", postUri);
    SWBFormMgr forMgr = new SWBFormMgr(post.getSemanticObject(), null, SWBFormMgr.MODE_EDIT);
    WebSite model = paramRequest.getWebPage().getWebSite();
    String iconClass = "fa fa-edit";
    String mode = SWBFormMgr.MODE_EDIT;
    Boolean isCaptcha = request.getAttribute("isCaptcha") != null ? Boolean.parseBoolean(request.getAttribute("isCaptcha").toString()) : false;
    String action = request.getAttribute("lblAction") != null ? request.getAttribute("lblAction").toString() : "";
    String lblAction = paramRequest.getLocaleString("edit");
    if (!action.equals("")) {
        lblAction = paramRequest.getLocaleString("comment") + " " + paramRequest.getLocaleString("msg");
        forMgr = new SWBFormMgr(Post.frm_Post, model.getSemanticObject(), SWBFormMgr.MODE_CREATE);
        urlAction.setAction("replyPost");
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
        <div class="card">
            <form class="form-horizontal" id="formSavePost" method="post" action="<%=urlAction%>">
                <div class="card-body">
                    <% if (!flag.equals("")) { %>
                        <div class="alert alert-warning alert-dismissable"> 
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
			</div>
                    <% 						}
                        out.print(forMgr.getFormHiddens());
                        if (!action.equals("")) { 
                    %>
                            <div class="card-answer-txt">
				<%=SWBUtils.TEXT.parseHTML(post.getBody())%>
                            </div>
                            <div class="card-answer-dateuser">
                                <span><%=post.getCreator().getFullName()%></span>
                            </div>
                    <%	
                        }
                    %>
                        <p class="card-answer-title"><%=SWBUtils.TEXT.parseHTML(forMgr.renderLabel(request, org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody, mode))%></p>
                    <%
                        String inputTitle = forMgr.renderElement(request, org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody, mode);
			String valueparse = SWBUtils.TEXT.parseHTML(inputTitle.substring(inputTitle.indexOf(">")+1, inputTitle.indexOf("<", 1)));
			out.println("<textarea name='pstBody' id='pstBody'>"+valueparse+"</textarea>");
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
					<button type="button" class="btn btn-cancel" onclick="window.location.replace('<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW).setAction("viewPost").setParameter("threadUri", threadUri)%>');"><%=paramRequest.getLocaleString("cancel")%></button>
					<button type="submit" class="btn" id="btnSavePost"><%=paramRequest.getLocaleString("send")%></button>
				</div>
			</form>
		</div>
	</div>
</div>
<script>
   document.getElementById("pstBody").focus();
   $('#btnSavePost').click(function() {
        console.log('on validate ');
        var $inputs = $('#formSavePost :input');
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
            var forma = document.getElementById('formSavePost');
            forma.submit();
        }
        return false;
    });
</script>          
    