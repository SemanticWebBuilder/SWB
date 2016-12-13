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
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.platform.SemanticProperty"%>
<%@page import="org.semanticwb.model.SWBModel"%>
<%@page import="org.semanticwb.model.Descriptiveable"%>
<%@page import="org.semanticwb.platform.SemanticClass"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<%@page import="org.semanticwb.portal.SWBFormButton"%>
<%@page import="org.semanticwb.portal.community.*"%>

<%
           User user = paramRequest.getUser();
           Resource base = paramRequest.getResourceBase();
           SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("uri"));
           if (semObject == null)
           {
               response.sendError(404);
               return;
           }
           SWBFormMgr mgr = new SWBFormMgr(semObject, null, SWBFormMgr.MODE_EDIT);
           String lang = "";
           if (paramRequest.getUser() != null)
           {
               lang = paramRequest.getUser().getLanguage();
           }
           mgr.setLang(lang);
           mgr.setSubmitByAjax(false);
           mgr.setType(mgr.TYPE_DOJO);
           SWBResourceURL url = paramRequest.getActionUrl();
           url.setParameter("uri", semObject.getURI());
           url.setAction(url.Action_EDIT);
           mgr.setAction(url.toString());

           String basepath = SWBPortal.getWebWorkPath() + "/" + semObject.getWorkPath() + "/";
           DirectoryObject dirObj = (DirectoryObject) semObject.createGenericInstance();
           String dirPhoto = dirObj.getPhoto();
           if (dirPhoto != null)
           {
               String photo = basepath + dirPhoto;
               request.setAttribute("attach_dirPhoto_1", photo);
               request.setAttribute("attachTarget_dirPhoto_1", "blank");
               request.setAttribute("attachCount_dirPhoto", "1");
               mgr.addHiddenParameter("dirPhotoHidden", dirPhoto);
           }

           int count = 0;
           Iterator<String> itPhotos = dirObj.listExtraPhotos();
           while (itPhotos.hasNext())
           {
               count++;
               String photo = itPhotos.next();
               request.setAttribute("attach_dirHasExtraPhoto_" + count, basepath + photo);
               request.setAttribute("attachTarget_dirHasExtraPhoto_" + count, "blank");
               mgr.addHiddenParameter("dirHasExtraPhotoHidden", photo);
           }
           if (count > 0)
           {
               request.setAttribute("attachCount_dirHasExtraPhoto", "" + count);
           }

           request.setAttribute("formName", mgr.getFormName());
           mgr.hideProperty(Rankable.swb_rank);
           mgr.hideProperty(Rankable.swb_reviews);
           mgr.addButton(SWBFormButton.newSaveButton());
           mgr.addButton(SWBFormButton.newBackButton());
           if (user.isRegistered() && user.isSigned())
           {
%>
<%=mgr.renderForm(request)%>
<%}
        else
        {%>
<p><span class="tituloRojo">NOTA: </span>Debe estar registrado y haber iniciado sesi&oacute;n para poder editar elementos.</p>
<%}%>
