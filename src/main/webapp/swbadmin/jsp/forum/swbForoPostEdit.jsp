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
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/bootstrap/bootstrap.css">
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/fontawesome/font-awesome.css">
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

    //String lblAction = paramRequest.getLocaleString("edit");
    String action = request.getAttribute("lblAction") != null ? request.getAttribute("lblAction").toString() : "";
    String lblAction = paramRequest.getLocaleString("edit");
    if (!action.equals("")) {
        lblAction = paramRequest.getLocaleString("comment") + " " + paramRequest.getLocaleString("msg");
        forMgr = new SWBFormMgr(Post.frm_Post, model.getSemanticObject(), SWBFormMgr.MODE_CREATE);
        urlAction.setAction("replyPost");
    }
    String flag = request.getParameter("flag") != null ? request.getParameter("flag").toString() : "";
%>
<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <form class="form-horizontal" id="formSavePost" method="post" action="<%=urlAction%>">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-title">
                        <span class="<%=iconClass%>"></span>
                        <strong><%=lblAction%></strong>
                    </div>
                </div>
                <div class="panel-body">
                    <%if (!flag.equals("")) {%>
                    <div class="alert alert-warning alert-dismissable">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                    </div>
                    <%}
                        out.print(forMgr.getFormHiddens());
                        if (!action.equals("")) {%>
                    <ul class="list-group">
                        <li class="list-group-item">
                            <span class="fa fa-comment"></span>
                            <strong><%=paramRequest.getLocaleString("msg")%>:</strong>
                            <%=post.getBody()%>
                        </li>
                        <li class="list-group-item">
                            <span class="fa fa-user"></span>
                            <strong><%=paramRequest.getLocaleString("autor")%>:</strong>
                            <%=post.getCreator().getFullName()%>
                        </li>
                    </ul>
                    <%}%>
                    <div class="form-group" id="div<%=org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody.getName()%>">
                        <label for="" class="col-lg-3 control-label"><%=SWBUtils.TEXT.parseHTML(forMgr.renderLabel(request, org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody, mode))%></label>
                        <div class="col-lg-9">
                            <%
                                String inputTitle = forMgr.renderElement(request, org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody, mode);
                                inputTitle = inputTitle.replaceFirst(">", " required class=\"form-control\" rows=\"8\" id=\"" + org.semanticwb.portal.resources.sem.forum.Post.frm_pstBody.getName() + "\">");
                                inputTitle = inputTitle.replace(inputTitle.substring(inputTitle.indexOf("style"), (inputTitle.indexOf("px;\"") + 4)), "");
                                out.println(inputTitle);
                            %>
                        </div>
                    </div>
                    <%if (isCaptcha) {%>
                    <div class="form-group" id="divcmnt_seccode">
                        <label for="" class="col-lg-3 control-label"><%="Captcha *:"%></label>
                        <div class="col-lg-4">
                            <%="<img src=\"" + SWBPlatform.getContextPath() + "/swbadmin/jsp/securecode.jsp\" alt=\"\" id=\"imgseccode\" width=\"155\" height=\"65\" />"%>
                        </div>
                        <div class="col-lg-5">
                            <%="<input class=\"form-control\" required type=\"text\" name=\"cmnt_seccode\" value=\"\"/>"%>

                        </div>
                    </div>
                    <%}%>

                </div>
                <div class="panel-footer text-right">
                    <a class="btn btn-default" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW).setAction("viewPost").setParameter("threadUri", threadUri)%>"> 
                        <span class="fa fa-mail-reply"></span>
                        <%=paramRequest.getLocaleString("cancel")%></a>
                    <button type="submit" class="btn btn-success" id="btnSavePost">
                        <span class="fa fa-save"></span>
                        <%=paramRequest.getLocaleString("send")%></button>
                </div>
            </div>
        </form>
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