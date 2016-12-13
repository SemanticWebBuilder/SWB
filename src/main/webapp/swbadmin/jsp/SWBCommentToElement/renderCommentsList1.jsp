<%-- 
    Document   : renderCommentsList1
    Created on : 12-jul-2013, 0:52:04
    Author     : carlos.ramos
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.IOException
                ,java.util.Iterator
                ,java.util.List
                ,javax.servlet.RequestDispatcher
                ,javax.servlet.http.*
                ,org.semanticwb.SWBUtils
                ,org.semanticwb.SWBPortal
                ,org.semanticwb.SWBPlatform
                ,org.semanticwb.model.Resource
                ,org.semanticwb.model.SWBClass
                ,org.semanticwb.model.SWBComparator
                ,org.semanticwb.model.User
                ,org.semanticwb.model.WebPage
                ,org.semanticwb.model.WebSite
                ,org.semanticwb.platform.SemanticObject
                ,org.semanticwb.portal.resources.sem.SWBCommentToElement
                ,org.semanticwb.portal.resources.sem.CommentToElement
                ,org.semanticwb.portal.api.SWBParamRequest
                ,org.semanticwb.portal.api.SWBResourceException
                ,org.semanticwb.portal.api.SWBResourceURL" %>
<%@ page import="static org.semanticwb.portal.resources.sem.SWBCommentToElement.*" %>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<jsp:useBean id="res" scope="request" type="org.semanticwb.portal.resources.sem.SWBCommentToElement"/>
<jsp:useBean id="element" scope="request" type="org.semanticwb.model.SWBClass"/>
<%!
    public String renderListComments(SWBParamRequest paramRequest, Iterator<CommentToElement> icomments, final int blockSize) throws SWBResourceException
    {
        StringBuilder html = new StringBuilder();
        final User user = paramRequest.getUser();
        final String lang = user.getLanguage()==null?"es":user.getLanguage();
        String name;
        
        if(icomments.hasNext())
        {
            html.append("  <ul class=\"swb-comments-lst\">");
            for(int i=blockSize; i>0&&icomments.hasNext(); i--) {
                CommentToElement comment = icomments.next();
                html.append("  <li class=\"swb-cmmts-item\" id=\"item_"+comment.getId()+"\">");
                html.append("   <p class=\"swb-cmmts-name\">"+(comment.getCreator()==null?comment.getName():comment.getCreator().getFullName()));
                try {
                    html.append("&nbsp;<span class=\"swb-cmmts-ago\">"+paramRequest.getLocaleString("ago")+"&nbsp;"+SWBUtils.TEXT.getTimeAgo(comment.getCreated(), lang)+"</span>");
                }catch(Exception e) {
                }
                html.append("   </p>");
                html.append("   <p class=\"swb-cmmts-cmmt\">"+comment.getCommentToElement()+"</p>");
                html.append("   <p><a href=\"javascript:answerBack('cmmt_"+comment.getId()+"','child_"+comment.getId()+"', 'last','"+comment.getId()+"')\">"+paramRequest.getLocaleString("answerBack") +"</a></p>");
//                if(comment.getAnswerBackTo()!=null) {
//                    html.append("<div class=\"swb-commts-ans\" id=\"cmmt_"+comment.getId()+"\">");
//                    html.append(paramRequest.getLocaleString("inAnswerTo")+"&nbsp;");
//                    html.append(comment.getAnswerBackTo().getCreator()==null?comment.getAnswerBackTo().getName():comment.getAnswerBackTo().getCreator().getFullName());
//                    html.append("&nbsp;<a href=\"javascript:postHtml('"+paramRequest.getRenderUrl().setCallMethod(SWBParamRequest.Call_DIRECT).setMode(Mode_DETAIL).setParameter("cmmt", comment.getEncodedURI())+"','item_"+comment.getId()+"')\" title=\""+paramRequest.getLocaleString("showComment")+"\">("+paramRequest.getLocaleString("showComment")+")</a>");
//                    html.append("</div>");
//                }else {
                    html.append("   <div class=\"swb-commts-ans\" id=\"cmmt_"+comment.getId()+"\"></div>");
//                }
                //réplica a comentario-inicio
                Iterator<CommentToElement> answers = comment.listAnswerBacks();
                if(answers.hasNext())
                {
                    answers = SWBComparator.sortByCreated(answers, false);
                    html.append("  <ul class=\"swb-comments-anslst\">");
                    while(answers.hasNext()) {
                        comment = answers.next();
                        html.append("  <li class=\"swb-cmmts-ansitem\">");
                        html.append("   <p class=\"swb-cmmts-ansname\">"+(comment.getCreator()==null?comment.getName():comment.getCreator().getFullName()));
                        try {
                            html.append("&nbsp;<span class=\"swb-cmmts-ansago\">"+paramRequest.getLocaleString("ago")+"&nbsp;"+SWBUtils.TEXT.getTimeAgo(comment.getCreated(), lang)+"</span>");
                        }catch(Exception e) {
                        }
                        html.append("   </p>");
                        html.append("   <p class=\"swb-cmmts-anscmmt\">"+comment.getCommentToElement()+"</p>");
                        html.append("  </li>");
                    }
                    html.append("  </ul>");                        
                }
                //réplica a comentario-fin
                html.append("  </li>");
            }
            html.append(" </ul>");
            
        }else {
            html.append("<p class=\"swb-comments-noe\">"+paramRequest.getLocaleString("noComment")+"</p>");
        }
        return html.toString();
    }

    public List<CommentToElement> listCommentToElementByElement(SWBClass value, org.semanticwb.model.SWBModel model)
    {
        CommentToElement comment;
        Iterator<CommentToElement> it = CommentToElement.ClassMgr.listCommentToElementByElement(value, model);
        it = SWBComparator.sortByCreated(it, false);
        List<CommentToElement> lst = SWBUtils.Collections.copyIterator(it);
        it = lst.iterator();
        while(it.hasNext()) {
            comment = it.next();
            if(!comment.isValid() || comment.getAnswerBackTo()!=null) {
                it.remove();
            }
        }
        return lst;
    }
%>
<%
    List<CommentToElement> commentsList = listCommentToElementByElement(element, paramRequest.getWebPage().getWebSite());
    out.println("<div class=\"swb-comments-lst\">");
    if(!commentsList.isEmpty())
    {
        out.println("<p class=\"swb-comments-lblcmmt\">"+paramRequest.getLocaleString("lblComments")+"</p>");
        out.println(" <div class=\"swb-comments-box\" id=\"commts\">");
        out.println(renderListComments(paramRequest, commentsList.iterator(), res.getBlockSize()));
        if(commentsList.size()>res.getBlockSize()) {
            out.println("<p><a href=\"javascript:postHtml('"+paramRequest.getRenderUrl().setCallMethod(SWBResourceURL.Call_DIRECT).setMode(SWBResourceURL.Mode_INDEX).setParameter("suri",element.getEncodedURI()).setParameter(FCTR,"_")+"','commts')\" title=\""+paramRequest.getLocaleString("viewMore")+"\">"+paramRequest.getLocaleString("viewMore")+"</a></p>");
        }
        out.println("</div>");
    }
    else
    {
        out.println("<p class=\"swb-comments-noe\">"+paramRequest.getLocaleString("noComment")+"</p>");
    }
    out.println("</div>");
%>