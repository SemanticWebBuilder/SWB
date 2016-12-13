<%@page import="org.semanticwb.resources.sem.forumcat.SWBForumCatResource"%>
<%@page import="org.semanticwb.resources.sem.forumcat.Question"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURLImp"%>
<%@page import="org.semanticwb.portal.api.SWBParamRequest"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.resources.sem.forumcat.QuestionSubscription"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.Tagable"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.model.SWBComparator"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>

<script type="text/javascript">
    function validateFields(form) {
        var element = document.getElementById('catfield');
        var index = element.selectedIndex;
        var val1 = document.getElementById('questionfield').value;
        var val2 = document.getElementById('tagsfield').value;
        if (val1.trim() == "") {
            alert('Debe escribir una pregunta');
            return false;
        } else if (index == 0) {
            alert('Debe seleccionar un tema');
            return false;
        } else if (val1.trim() != "" && val2.trim() != "") {
            return true;
        }
    }
</script>

<%
SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
SWBForumCatResource resource = (SWBForumCatResource) request.getAttribute("forumResource");
User user = paramRequest.getUser();
String baseimg = SWBPortal.getWebWorkPath()+"/models/"+paramRequest.getWebPage().getWebSiteId()+"/css/images/";

if (resource != null && resource.getResource().isValid()) {
    SWBResourceURL actionURL = new SWBResourceURLImp(request, resource.getResource(), paramRequest.getWebPage(), SWBResourceURL.UrlType_ACTION);
    //SWBFormMgr mgr = new SWBFormMgr(Question.forumCat_Question, resource.getSemanticObject(), SWBFormMgr.MODE_CREATE);
    //mgr.setLang(user.getLanguage());
    //mgr.setFilterRequired(false);
    //mgr.setType(mgr.TYPE_DOJO);

    SWBFormMgr mgr = new SWBFormMgr(Question.sclass, paramRequest.getWebPage().getWebSite().getSemanticObject(), null);
    mgr.setLang(user.getLanguage());
    mgr.setSubmitByAjax(false);
    mgr.setType(mgr.TYPE_DOJO);
    actionURL.setAction("addQuestion");
    mgr.setAction(actionURL.toString());
    %>
    <div id="preguntar"><h2>¿Qu&eacute; quieres preguntar?</h2>
        <form action="<%=actionURL%>" method="post">
            <%= mgr.getFormHiddens()%>
            <input type="hidden" name="<%=Question.forumCat_hasQuestionAttachments.getName()%>">
            <textarea id="questionfield" rows ="2" cols="34" name="<%=Question.forumCat_question.getName()%>"></textarea>
            <p>Etiqueta tu pregunta</p>
            <input id="tagsfield" type="text" name="<%=Tagable.swb_tags.getName()%>" size="34" class="etiqueta"/>
            <%
            Iterator<WebPage> childs = SWBComparator.sortByDisplayName(paramRequest.getWebPage().getWebSite().getWebPage(resource.getIdCatPage()).listChilds(), user.getLanguage());
                %>
                <p>Clasifica tu pregunta</p>
                <select id="catfield" name="categoryuri">
                    <option value="" selected>Selecciona un tema</option>
                    <%
                    while (childs.hasNext()) {
                        WebPage child = childs.next();
                        %><option value="<%=child.getURI()%>"><%=child.getTitle()%></option><%
                    }
                    %>
                </select>
            <input name="publicar" type="image" class="btn_publicar" src="<%=baseimg%>btn_compartir.png" onclick="return validateFields(this.form);"/>
        </form>
    </div>
<%
}
%>