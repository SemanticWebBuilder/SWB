<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*,org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.community.PhotoElement,org.semanticwb.portal.SWBFormButton"%>

<%
    SWBParamRequest paramRequest=(SWBParamRequest)request.getAttribute("paramRequest");
    WebSite website=paramRequest.getWebPage().getWebSite();
    Resource base=paramRequest.getResourceBase();
    User user=paramRequest.getUser();
    WebPage wpage=paramRequest.getWebPage();
    Member member=Member.getMember(user,wpage);    
%>
<%
        String uri=request.getParameter("uri");
        SemanticObject semObject = SemanticObject.createSemanticObject(uri);
        ProductElement rec=(ProductElement)semObject.createGenericInstance();
        if(semObject==null)
        {
%>
            Error: Elemento no encontrado...
<%
            return;
        }
        String lang="es";
        
        SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_EDIT);
        if (paramRequest.getUser() != null) {
            lang = paramRequest.getUser().getLanguage();
        }
        mgr.setLang(lang);
        mgr.setSubmitByAjax(false);
        mgr.setType(mgr.TYPE_XHTML);
        SWBResourceURL url = paramRequest.getActionUrl();
        url.setParameter("uri", semObject.getURI());
        url.setParameter("act","edit");
        mgr.setAction(url.toString());

        String smallPhoto=rec.getSmallPhoto();
        String bigPhoto=rec.getSmallPhoto();

        if(smallPhoto!=null){
            String basepath = SWBPortal.getWebWorkPath() + "/models/" + website.getId() + "/Resource/" + base.getId() + "/products/" + semObject.getId() + "/" + smallPhoto;
            request.setAttribute("attach_1", basepath);
            request.setAttribute("attachTarget_1", "blank");
            request.setAttribute("attachCount", "1");
            mgr.addHiddenParameter("smallPhotoHidden", smallPhoto);
        }

        mgr.addButton(SWBFormButton.newSaveButton());
        mgr.addButton(SWBFormButton.newCancelButton());
        request.setAttribute("formName", mgr.getFormName());
        out.println(mgr.renderForm(request));


%>
