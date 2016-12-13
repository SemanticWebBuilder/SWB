<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*,org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.community.PhotoElement,org.semanticwb.portal.SWBFormButton"%>

<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    
    String lang="es";
    SWBFormMgr mgr = new SWBFormMgr(PhotoElement.swbcomm_PhotoElement, paramRequest.getWebPage().getSemanticObject(), null);
    if (paramRequest.getUser() != null) {
        lang = paramRequest.getUser().getLanguage();
    }
    mgr.setLang(lang);
    mgr.setSubmitByAjax(false);
    mgr.setType(mgr.TYPE_XHTML);
    SWBResourceURL url = paramRequest.getActionUrl();
    url.setParameter("act","add");
    mgr.setAction(url.toString());

    request.setAttribute("formName", mgr.getFormName());
    mgr.addButton(SWBFormButton.newSaveButton());
    mgr.addButton(SWBFormButton.newCancelButton());
    out.println(mgr.renderForm(request));
%>