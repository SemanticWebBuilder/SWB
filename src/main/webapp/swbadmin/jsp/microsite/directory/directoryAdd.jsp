<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.Rankable"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.platform.SemanticProperty"%>
<%@page import="org.semanticwb.model.SWBModel"%>
<%@page import="org.semanticwb.model.Descriptiveable"%>
<%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.SWBFormButton"%>


    <%
        WebSite site=paramRequest.getWebPage().getWebSite();
        User user = paramRequest.getUser();
        SemanticClass cls = SWBPlatform.getSemanticMgr().getVocabulary().getSemanticClass(request.getParameter("uri"));
        SWBFormMgr mgr = new SWBFormMgr(cls, site.getSemanticObject(), null);
        mgr.setFilterRequired(false);
        String lang="";
        if (paramRequest.getUser() != null) {
            lang = paramRequest.getUser().getLanguage();
        }
        mgr.setLang(lang);
        mgr.setSubmitByAjax(false);
        mgr.setType(mgr.TYPE_DOJO);
        SWBResourceURL url = paramRequest.getActionUrl();
        url.setParameter("uri", cls.getURI());
        url.setAction(url.Action_ADD);
        mgr.setAction(url.toString());
        request.setAttribute("formName", mgr.getFormName());
        mgr.hideProperty(Rankable.swb_rank);
        mgr.hideProperty(Rankable.swb_reviews);
        mgr.addButton(SWBFormButton.newSaveButton());
        mgr.addButton(SWBFormButton.newBackButton());
        if (user.isRegistered() && user.isSigned()) {
      %>
        <%=mgr.renderForm(request)%>
      <%} else {%>
      <p><span class="tituloRojo">NOTA: </span>Debe estar registrado y haber iniciado sesi&oacute;n para poder publicar elementos.</p>
      <%}%>