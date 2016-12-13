<%@page import="java.util.List"%>
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="org.semanticwb.portal.api.SWBResourceURL"%>
<%@page import="org.semanticwb.model.WebPage"%>
<%@page import="org.semanticwb.model.WebSite"%>
<%@page import="org.semanticwb.model.User"%>
<%@page import="org.semanticwb.model.Resource"%>
<%@page import="org.semanticwb.model.GenericIterator"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.UserFavThread"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.SWBForum"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.Thread"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.Post"%>
<%@page import="org.semanticwb.portal.resources.sem.forum.Attachment"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBPortal"%>
<%@page import="org.semanticwb.model.*"%>
<%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="org.semanticwb.portal.SWBFormButton"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%>
<!--
<style type="text/css">
* {
        margin: 0px;
        padding: 0px;
        font-size: 100%;
        vertical-align: baseline;
}

body {
        font-family: Arial, Helvetica, sans-serif;
        background-repeat: no-repeat;
}
p {margin-bottom: 10px; color: #626262;	font-size: 0.7em;}
a {text-decoration: none;}
a:hover {text-decoration: underline;}
</style>
-->

<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/bootstrap/bootstrap.css">
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/fontawesome/font-awesome.css">
<%
    WebPage webpage = paramRequest.getWebPage();
    Resource base = paramRequest.getResourceBase();
    SWBForum oforum = (SWBForum) SWBPortal.getResourceMgr().getResource(base);
    String flag = request.getAttribute("flag") != null ? request.getAttribute("flag").toString() : "";
    WebSite website = webpage.getWebSite();
    SWBResourceURL urlthread = paramRequest.getRenderUrl();
    SWBResourceURL url = paramRequest.getRenderUrl();
    SWBResourceURL urlRemovePost = paramRequest.getRenderUrl();
    SWBResourceURL actionURL = paramRequest.getActionUrl();
    User user = paramRequest.getUser();
    boolean acceptguesscomments = false;
    if (request.getAttribute("acceptguesscomments") != null) {
        acceptguesscomments = (Boolean) request.getAttribute("acceptguesscomments");
    }
    boolean isforumAdmin = user.hasRole(oforum.getAdminRole());
    String lang = user.getLanguage();
    String action = paramRequest.getAction();
    String autor = "";
    if (action != null && action.equals("viewPost")) {
        SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("threadUri"));
        Thread thread = Thread.ClassMgr.getThread(semObject.getId(), website);
        if (request.getParameter("addView") != null) {
            thread.setViewCount(thread.getViewCount() + 1);
        }
        url.setParameter("threadUri", thread.getURI());
        urlRemovePost.setParameter("threadUri", thread.getURI());
        //urlthread.setParameter("threadUri", thread.getURI());
        urlthread.setMode("addThread");
        boolean isTheAuthor = false;
        if (thread.getCreator() != null) {
            autor = thread.getCreator().getFullName();
            if (thread.getCreator().getURI().equals(user.getURI())) {
                isTheAuthor = true;
            }
        }
%>
<!-- Begin view Post -->
<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default swbp-panel">
            <div class="panel-heading swbp-panel-title">
                    <span class="fa fa-comments"></span> <%=paramRequest.getLocaleString("lblComments")%>
                    <div class="pull-right">
                        <%
                            if (isTheAuthor || isforumAdmin) {
                                urlthread.setMode("editThread");
                        %>
                        <a class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Editar tema" href="<%=urlthread.setParameter("threadUri", thread.getURI())%>">
                            <span class="fa fa-pencil"></span>
                        </a>
                        <%
                            }
                            if (isTheAuthor || isforumAdmin) {
                                url.setAction("removePost");
                                url.setParameter("isthread", "1");
                                actionURL.setAction("removeThread");
                                actionURL.setParameter("forumUri", request.getParameter("forumUri"));
                        %>
                        <a class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Eliminar tema" onclick="if (!confirm('<%=paramRequest.getLocaleString("remove")%> <%=thread.getTitle()%>?'))
                                                return false;" href="<%=actionURL.setParameter("threadUri", thread.getURI())%>">
                            <span class="fa fa-trash-o"></span>
                        </a>
                        <%
                            }
                        %>
                        <a href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW)%>" class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Volver a lista de temas">
                            <span class="fa fa-reply"></span>
                        </a>
                    </div>
            </div>
            <div class="panel-body">
                <%if (!flag.equals("")) {%>
                <div class="alert alert-warning alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                </div>
                <%}%>
                <ul class="list-group swbp-foro-date">
                    <li class="list-group-item"><span class="fa fa-comments fa-fw"></span><strong><%=paramRequest.getLocaleString("thread")%>:</strong>  <%=thread.getTitle()%></li>
                    <li class="list-group-item"><span class="fa fa-user fa-fw"></span><strong><%=paramRequest.getLocaleString("autor")%>:</strong> <%=autor%></li>
                            <%
                                String text = thread.getBody() != null ? thread.getBody() : "";
                                thread.setViewCount((thread.getViewCount() + 1));
                            %>
                    <li class="list-group-item"><span class="fa fa-file fa-fw"></span><strong><%=paramRequest.getLocaleString("lblContent")%>:</strong> <%=SWBUtils.TEXT.replaceAll(text, "\n", "<br>")%></li>
                    <li class="list-group-item"><span class="fa fa-comment fa-fw"></span><strong><%=paramRequest.getLocaleString("responses")%>:</strong> <%=thread.getReplyCount()%> </li>
                    <li class="list-group-item"><span class="fa fa-eye fa-fw"></span><strong><%=paramRequest.getLocaleString("visites")%>:</strong> <%=thread.getViewCount()%></li>
                </ul>

                <%
                    SWBFormMgr mgr = new SWBFormMgr(Post.frm_Post, thread.getSemanticObject(), null);
                    String photo = SWBPlatform.getContextPath() + "/swbadmin/images/defaultPhoto.png";
                    if ((user != null && user.isRegistered()) || acceptguesscomments) {
                        //mgr.setCaptchaStatus(true);
                        actionURL.setParameter("threadUri", thread.getURI());
                        actionURL.setAction("replyPost");
                        lang = user.getLanguage();
                        //mgr.setLang(lang);
                        //mgr.setSubmitByAjax(false);
                        //mgr.setType(mgr.TYPE_DOJO);
                        //mgr.hideProperty(Post.frm_hasAttachments);
                        //mgr.setType(mgr.TYPE_XHTML);
                        //mgr.setAction(actionURL.toString());
                        //mgr.addButton(SWBFormButton.newSaveButton());
                        //mgr.addButton(SWBFormButton.newBackButton());
                        //request.setAttribute("formName", mgr.getFormName());

                %>
                <%//mgr.renderForm(request)%>
                <div class="row">
                    <h5><strong><%=paramRequest.getLocaleString("lblLeaveMessage")%></strong></h5>
                    <br>
                    <hr>
                    <form class="form-horizontal" method="post" action="<%=actionURL%>" id="formSavePost">
                        <%=mgr.getFormHiddens()%>
                        <div class="form-group" id="div<%=Post.frm_pstBody.getName()%>">
                            <label for="" class="col-lg-2 control-label"><%=Post.frm_pstBody.getDisplayName()%> *:</label>
                            <div class="col-lg-10">
                                <%
                                    String inputfm = mgr.renderElement(request, Post.frm_pstBody, SWBFormMgr.MODE_CREATE);
                                    inputfm = inputfm.replaceFirst(">", " required class=\"form-control\">");
                                    inputfm = inputfm.replace(inputfm.substring(inputfm.indexOf("style"), (inputfm.indexOf("px;\"") + 4)), "");
                                    out.println(inputfm);
                                %>
                            </div>
                        </div>
                        <%
                            Boolean isCaptcha = request.getAttribute("isCaptcha") != null ? Boolean.parseBoolean(request.getAttribute("isCaptcha").toString()) : false;
                        %>
                        <%if (isCaptcha) {%>
                        <div class="form-group" id="divcmnt_seccode">
                            <label for="" class="col-lg-2 control-label"><%="Captcha *:"%></label>
                            <div class="col-lg-4">
                                <%="<img src=\"" + SWBPlatform.getContextPath() + "/swbadmin/jsp/securecode.jsp\" alt=\"\" id=\"imgseccode\" width=\"155\" height=\"65\" />"%>
                            </div>
                            <div class="col-lg-6">
                                <%="<input class=\"form-control\" required type=\"text\" name=\"cmnt_seccode\" value=\"\"/>"%>
                            </div>
                        </div>
                        <%}%>

                        <div class="panel-footer text-right">
                            <button id="saveForm" class="btn btn-success" type="submit">
                                <span class="fa fa-save"></span>
                                <%=paramRequest.getLocaleString("send")%></button>
                        </div>
                    </form>
                </div>
            </div>
            <%
                    out.print(SWBForum.getScriptValidator("saveForm", "formSavePost"));
                }
                boolean cambiaColor = true;
                Iterator<Post> itPost = SWBComparator.sortByCreated(thread.listPosts(), false);
                if (itPost.hasNext()) {
            %>
            <ul class="list-group">
                <li class="list-group-item active"><span class="fa fa-comment fa-fw"></span><strong> <%=paramRequest.getLocaleString("responses")%></strong></li>
                        <%
                            while (itPost.hasNext()) {
                                Post post = itPost.next();
                                url.setParameter("postUri", post.getURI());
                                urlRemovePost.setParameter("postUri", post.getURI());
                                User userPost = null;
                                String postCreator = "Anonimo";
                                String postCreated = "";
                                isTheAuthor = false;
                                if (post.getCreator() != null) {
                                    userPost = post.getCreator();
                                    postCreator = post.getCreator().getFullName();
                                    if (post.getCreator().getPhoto() != null) {
                                        photo = SWBPortal.getWebWorkPath() + post.getCreator().getPhoto();
                                    }
                                    if (post.getCreator().getURI().equals(user.getURI())) {
                                        isTheAuthor = true;
                                    }
                                }
                                String rowClass = "pluginRow2";
                                if (!cambiaColor) {
                                    rowClass = "pluginRow1";
                                }
                                cambiaColor = !(cambiaColor);
                        %>
                <li class="list-group-item swbp-foro-respuestas">
                    <div class="img_ReplyForo"><span class="fa fa-user fa-5x"></span></div>
                    <p class="tituloNoticia"><%=postCreator%></p>
                    <p><%=post.getBody()%></p>
                    <p><%=SWBUtils.TEXT.getTimeAgo(post.getUpdated(), user.getLanguage())%></p>
                    <%
                        urlRemovePost.setAction("removePost");
                        urlthread.setMode("replyPost");
                        urlthread.setParameter("postUri", post.getURI());
                        urlthread.setParameter("threadUri", thread.getURI());
                    %>
                    <div class="text-right"> 
                        <%
                            if ((user != null && user.isRegistered()) || acceptguesscomments) {
                        %>
                        <a class="btn btn-default" href="<%=urlthread%>">
                            <span class="fa fa-comment"></span>
                            <%=paramRequest.getLocaleString("comment")%></a>
                            <%
                                }
                                if (isTheAuthor || isforumAdmin) {
                                    urlthread.setMode("editPost");
                            %>
                        <a class="btn btn-default" href="<%=urlthread%>">
                            <span class="fa fa-pencil"></span>
                            <%=paramRequest.getLocaleString("edit")%>
                        </a>
                        <%
                            if (isTheAuthor || isforumAdmin) {
                                url.setAction("removePost");
                            }
                            actionURL.setAction("removePost");
                            actionURL.setParameter("threadUri", thread.getURI());
                        %>
                        <a class="btn btn-default" onclick="if (!confirm('<%=paramRequest.getLocaleString("remove")%> <%=post.getBody()%>?'))
                                                    return false;" href="<%=actionURL.setParameter("postUri", post.getURI())%>">
                            <span class="fa fa-trash-o"></span>
                            <%=paramRequest.getLocaleString("remove")%>
                        </a>
                    </div>
                    <%
                        }
                    %>
                </li>
                <%
                    }
                %>
            </ul>
            <%
                }
            %>
        </div>
    </div>
</div>
<!-- End viewPost -->
<%} else if (action != null && action.equals("removePost")) {
    if (request.getParameter("isthread") != null) {
        SemanticObject soThread = SemanticObject.createSemanticObject(request.getParameter("threadUri"));
        Thread thread = Thread.ClassMgr.getThread(soThread.getId(), website);
        actionURL.setAction("removeThread");
%>

<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default swbp-panel">
            <div class="panel-heading swbp-panel-title">
                <div class="panel-title">
                    <h1 class="panel-title">
                        <span class="fa fa-trash-o"></span>
                        <%=paramRequest.getLocaleString("threadData")%></h1>
                </div>
            </div>
            <div class="panel-body">
                <ul class="list-group">
                    <li class="list-group-item"><span class="fa fa-comments"></span><strong> <%=paramRequest.getLocaleString("thread")%>:</strong> <%=thread.getTitle()%></li>
                    <li class="list-group-item"><span class="fa fa-file"></span><strong> <%=paramRequest.getLocaleString("msg")%>:</strong> <%=thread.getBody()%></li>
                    <li class="list-group-item"><span class="fa fa-user"></span><strong> <%=paramRequest.getLocaleString("autor")%>:</strong> <%if (thread.getCreator() != null) {%><%=thread.getCreator().getFullName()%><%}%></li>
                    <li class="list-group-item">
                        <span class="fa fa-comments-o"></span><strong> <%=paramRequest.getLocaleString("noMsgs")%>:</strong> <%
                            int postSize = 0;
                            GenericIterator<Post> itPost = thread.listPosts();
                            while (itPost.hasNext()) {
                                Post post = itPost.next();
                                postSize++;
                            }
                            %>
                            <%=postSize%>
                    </li>
                    <!--li class="list-group-item"><span class="fa fa-file"></span><strong> <%//paramRequest.getLocaleString("noAttachments")%>:</strong> <%
                        /*int attchmentsSize = 0;
                         GenericIterator<Attachment> itattach = thread.listAttachments();
                         while (itattach.hasNext()) {
                         itattach.next();
                         attchmentsSize++;
                         }*/
                    %>
                    <%//attchmentsSize%>
            </li>
            <li class="list-group-item"><span class="fa fa-files-o"></span><strong> <%//paramRequest.getLocaleString("totAttach")%>:</strong> <%
                /*int attchmentsTotSize = attchmentsSize;
                 itPost = thread.listPosts();
                 while (itPost.hasNext()) {
                 attchmentsTotSize = getTotAttachments(itPost.next(), attchmentsTotSize);
                 }*/
                    %>
                    <%//attchmentsTotSize%>
            </li-->
                </ul>
            </div>
            <div class="panel-footer text-right">
                <form name="removeThread" action="<%=actionURL.toString()%>">
                    <input type="hidden" name="threadUri" value="<%=thread.getURI()%>">
                    <input type="hidden" name="forumUri" value="<%=request.getParameter("forumUri")%>">
                    <button type="button" class="btn btn-default" onClick="retorna(this.form);">
                        <span class="fa fa-mail-reply"></span>
                        <%=paramRequest.getLocaleString("cancel")%></button>
                    <button type="submit" class="btn btn-success">
                        <span class="fa fa-trash-o"></span>
                        <%=paramRequest.getLocaleString("remove")%></button>
                </form>
            </div>
        </div>
    </div>
</div>
<%} else {
    actionURL.setAction("removePost");
    SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("postUri"));
    Post post = Post.ClassMgr.getPost(semObject.getId(), paramRequest.getWebPage().getWebSite());
%>

<!-- Begin remove Post -->
<div class="row">
    <div class="col-lg-6 col-lg-offset-3">
        <div class="panel panel-default swbp-panel">
            <div class="panel-heading swbp-panel-title">
                <div class="panel-title">
                    <h1 class="panel-title">
                        <span class="fa fa-trash-o"></span>
                        <%=paramRequest.getLocaleString("PostData")%></h1>
                </div>
            </div>
            <div class="panel-body">
                <ul class="list-group">
                    <li class="list-group-item"><span class="fa fa-comments"></span><strong> <%=paramRequest.getLocaleString("thread")%>:</strong> <%=post.getThread().getTitle()%></li>
                    <li class="list-group-item"><span class="fa fa-file"></span><strong> <%=paramRequest.getLocaleString("msg")%>:</strong> <%=post.getBody()%></li>
                    <li class="list-group-item"><span class="fa fa-user"></span><strong> <%=paramRequest.getLocaleString("autor")%>:</strong> <%if (post.getCreator() != null) {%><%=post.getCreator().getFullName()%><%}%></li>
                    <li class="list-group-item"><span class="fa fa-comments-o">
                        </span><strong> <%=paramRequest.getLocaleString("noResponse")%>:</strong>
                        <%
                            int attchmentsSize = 0;
                            GenericIterator<Attachment> itattach = post.listAttachmentses();
                            while (itattach.hasNext()) {
                                itattach.next();
                                attchmentsSize++;
                            }
                            int noAttach = attchmentsSize;
                            int postSize = 0;
                            String postandAttach = "0/0";
                            Iterator<Post> itPost = post.listchildPosts();
                            while (itPost.hasNext()) {
                                postSize++;
                                if (postandAttach.equals("0/0")) {
                                    postandAttach = postSize + "/" + noAttach;
                                } else {
                                    String[] posattachX = postandAttach.split("/");
                                    int postCount = Integer.parseInt(posattachX[0]) + 1;
                                    int AttachCount = Integer.parseInt(posattachX[1]);
                                    postandAttach = postCount + "/" + AttachCount;
                                }
                                postandAttach = getPostAndAttachments(itPost.next(), postandAttach);
                            }
                            String[] posattachX = postandAttach.split("/");
                            int postCount = Integer.parseInt(posattachX[0]);
                            int AttachCount = Integer.parseInt(posattachX[1]);
                        %>
                        <%=postCount%>
                    </li>
                </ul>
            </div>
            <div class="panel-footer text-right">
                <form name="removePost" action="<%=actionURL.toString()%>">
                    <input type="hidden" name="postUri" value="<%=post.getURI()%>">
                    <input type="hidden" name="threadUri" value="<%=request.getParameter("threadUri")%>">
                    <button type="button" class="btn btn-default" onClick="retorna(this.form);">
                        <span class="fa fa-mail-reply"></span>
                        <%=paramRequest.getLocaleString("cancel")%></button>
                    <button type="submit"class="btn btn-success">
                        <span class="fa fa-trash-o"></span>
                        <%=paramRequest.getLocaleString("remove")%></button>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- End remove Post -->
<%
    }
    url.setAction("viewPost");
%>
<script type="text/javascript">
    function retorna(forma) {
        forma.action = "<%=url.toString()%>";
        forma.submit();
    }
</script>
<%} else {
    url.setMode("addThread");
%>
<div class="row">
    <div class="col-lg-10 col-lg-offset-1">
        <div class="panel panel-default swbp-panel">
            <div class="panel-heading swbp-panel-title">
                <div class="panel-title">
                    <span class="fa fa-bullhorn"></span> Foro
                    <div class="pull-right">
                        <%
                            if (!oforum.isOnlyAdminCreateThreads() || isforumAdmin) {
                                if (user != null && user.isRegistered()) {
                        %>
                        <a class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Agregar tema" href="<%=url%>"><span class="fa fa-plus"></span></a>
                            <%
                                    }
                                }
                            %>
                        <%--a href="<%=webpage.getParent().getUrl(lang)%>" class="btn btn-success" data-toggle="tooltip" data-placement="bottom" title="Herramientas de colaboración">
                            <span class="fa fa-reply"></span>
                        </a--%>
                    </div>
                </div>
            </div>
            <div class="panel-body">
                <%

                    if (!flag.equals("")) {%>
                <div class="alert alert-warning alert-dismissable">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                    <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                </div>

                <%}
                    autor = "";
                    url.setMode(url.Mode_VIEW);
                    url.setAction("viewPost");
                    TreeSet<Thread> treeSet = new TreeSet(new Comparator() {
                        public int compare(Object o1, Object o2) {
                            Thread ob1 = (Thread) (o1);
                            Thread ob2 = (Thread) (o2);
                            int ret = -1;
                            if (ob1.getLastPostDate() != null && ob2.getLastPostDate() != null) {
                                ret = ob1.getLastPostDate().after(ob2.getLastPostDate()) ? -1 : 1;
                            }
                            return ret;
                        }
                    });

                    Iterator<Thread> iterator = request.getAttribute(SWBForum.ATT_THREADS) != null ? ((List<Thread>) request.getAttribute(SWBForum.ATT_THREADS)).iterator() : null;
                    /*System.out.println("iterator : " + iterator.hasNext());
                     while(iterator.hasNext()){
                     Thread thr = iterator.next();
                     System.out.println("thr : " + thr.getTitle());
                     }*/

                    Iterator<WebPage> itThreads = webpage.listChilds(null, null, false, null, null);

                    while (itThreads.hasNext()) {
                        WebPage wp = itThreads.next();
                        //System.out.println("treeSet:"+treeSet+" "+wp);
                        if (wp != null && wp instanceof Thread) {
                            treeSet.add((Thread) wp);
                        }
                    }
                    //Iterator<Thread> itThreads2 = treeSet.iterator();
                    Iterator<Thread> itThreads2 = request.getAttribute(SWBForum.ATT_THREADS) != null ? ((List<Thread>) request.getAttribute(SWBForum.ATT_THREADS)).iterator() : null;
                %>
                <ul class="list-group">
                    <%
                        int i = 0;
                        while (itThreads2.hasNext()) {
                            Thread thread = itThreads2.next();
                            url.setParameter("threadUri", thread.getURI());
                            if (thread.getCreator() != null) {
                                autor = thread.getCreator().getFullName();
                            }
                    %>
                    <li class="list-group-item">
                        <div class="row">
                            <div class="col-lg-5 swbp-foro-titulo">
                                <span <% if (thread.getViewCount() == 0) {%> class="fa fa-comments-o fa-2x" <%} else {%> class="fa fa-comments fa-2x"<%}%>></span>
                                <strong><%=thread.getTitle()%></strong> --
                                <i class="swbp-foro-user"><%=autor%></i> --
                                <i class="swbp-foro-date"><%=SWBUtils.TEXT.getStrDate(thread.getCreated(), user.getLanguage())%></i>
                                <%if (oforum.isShowThreadBody()) {
                                        String text = thread.getBody() != null ? thread.getBody() : "";
                                %>
                                <p class="swbp-foro-titulo-des"><%=SWBUtils.TEXT.replaceAll(text, "\n", "<br>")%></p>
                                <%}%>
                            </div>
                            <div class="col-lg-5">
                                <%
                                    String date = null;
                                %>
                                <p class="swbp-foro-ultimo-comentario">
                                    <%=paramRequest.getLocaleString("lastcomment")%>:
                                </p>
                                <p>
                                    <%
                                        date = "";
                                        Iterator<Post> itPost = SWBComparator.sortByCreated(thread.listPosts(), false);
                                        if (itPost.hasNext()) {
                                            Post post = itPost.next();
                                            out.print(post.getBody() + " -- " + (post.getCreator() != null ? post.getCreator().getFullName() : ""));
                                            if (thread.getLastPostDate() != null) {
                                                date = SWBUtils.TEXT.getTimeAgo(thread.getLastPostDate(), user.getLanguage());
                                                //out.print(" -- " + date);
                                            }
                                        } else {
                                            out.print(paramRequest.getLocaleString("nocomments"));
                                        }
                                    %>
                                </p>
                                <p><%=date%></p>
                            </div>
                            <div class="col-lg-2">
                                <a class="btn btn-default swbp-foro-bot" href="<%=url%>">
                                    <span class="fa fa-eye"></span>
                                    Ver comentarios</a>
                                <p class="swbp-foro-datos"><span class="fa fa-comment"></span> <%=paramRequest.getLocaleString("responses")%>: <%=thread.getReplyCount()%> </p>
                                <p class="swbp-foro-datos"><span class="fa fa-eye"></span> <%=paramRequest.getLocaleString("visites")%>: <%=thread.getViewCount()%> </p>
                            </div>
                        </div>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <jsp:include page="/swbadmin/jsp/forum/pagination.jsp" flush="true"/>
        </div>
    </div>
</div>

<script>
    $('#btnTheme').click(function() {
        var $inputs = $('#saveTheme :input');
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
            submitFormTheme('saveTheme');
            var forma = document.getElementById('saveTheme');
            forma.submit();
            return false;
        }
        return false;
    });
</script>
<%
    }
%>



<%!
    private String getPostAndAttachments(Post post, String posattach) {
        String[] posattachX = posattach.split("/");
        int postCount = Integer.parseInt(posattachX[0]);
        int AttachCount = Integer.parseInt(posattachX[1]);
        GenericIterator<Attachment> gitAttach = post.listAttachmentses();
        while (gitAttach.hasNext()) {
            gitAttach.next();
            AttachCount++;
        }
        posattach = postCount + "/" + AttachCount;
        GenericIterator<Post> gitPost = post.listchildPosts();
        while (gitPost.hasNext()) {
            posattachX = posattach.split("/");
            postCount = Integer.parseInt(posattachX[0]) + 1;
            AttachCount = Integer.parseInt(posattachX[1]);
            posattach = getPostAndAttachments(gitPost.next(), postCount + "/" + AttachCount);
        }
        return posattach;
    }

    private int getTotAttachments(Post post, int attchCount) {
        GenericIterator<Attachment> gitAttach = post.listAttachmentses();
        while (gitAttach.hasNext()) {
            gitAttach.next();
            attchCount++;
        }
        GenericIterator<Post> gitPost = post.listchildPosts();
        while (gitPost.hasNext()) {
            attchCount = getTotAttachments(gitPost.next(), attchCount);
        }
        return attchCount;
    }
%>