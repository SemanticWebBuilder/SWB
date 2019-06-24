<%@page import="java.util.List"%>
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
<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<script src="<%= SWBPortal.getContextPath() %>/swbadmin/js/tinymce/tinymce.min.js"></script>
<link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/jsp/forum/css/swbforum.css">
<link type="text/css" rel="stylesheet" href="<%= SWBPortal.getContextPath() %>/swbadmin/css/bootstrap/bootstrap.min.css">
<script>
    function fileName(blobInfo) {
        return Date.now()+"-"+blobInfo.filename();
    }
    function success(location) {
        document.getElementById("pstBody").value = location;
    }
    function failure(error) {
        document.getElementById("pstBody").value = '';
    }
</script>
<%
    SWBResourceURL imgURL = paramRequest.getRenderUrl().setMode("addImage");
    imgURL.setCallMethod(SWBParamRequest.Call_DIRECT);
    User user = paramRequest.getUser();
    String lang = user.getLanguage();
    String language = lang.equalsIgnoreCase("es") ? "es_MX" : lang;
%>
<script>
    tinymce.init({
        selector:'textarea',
	menubar: true,
        language: '<%=language%>',
	powerpaste_allow_local_images: true,
        plugins: [
            "anchor autolink colorpicker fullscreen image imagetools help ",
            " lists link media noneditable preview",
            " searchreplace table textcolor visualblocks wordcount"
	],
	toolbar: 'undo redo | forecolor backcolor | alignleft aligncenter alignright alignjustify | bullist numlist | link image tinydrive',
	image_uploadtab: true,
        images_upload_handler: function (blobInfo, success, failure) {
            var xhr, formData;
            xhr = new XMLHttpRequest();
            xhr.withCredentials = false;
            xhr.open('POST', '<%=imgURL%>');
            xhr.onload = function() {
                var json;
		if (xhr.status < 200 || xhr.status >= 300) {
                    failure('HTTP Error: ' + xhr.status);
                    return;
		}
		json = JSON.parse(xhr.responseText);
		if (!json || typeof json.location != 'string') {
                    failure('Invalid JSON: ' + xhr.responseText);
                    return;
		}
		success(json.location);
            };
            formData = new FormData();
            formData.append('file', blobInfo.blob(), fileName(blobInfo));
            xhr.send(formData);
        }
    });
</script>
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
    boolean acceptguesscomments = false;
    if (request.getAttribute("acceptguesscomments") != null) {
        acceptguesscomments = (Boolean) request.getAttribute("acceptguesscomments");
    }
    boolean isforumAdmin = user.hasRole(oforum.getAdminRole());
    String autor = "";
    String action = paramRequest.getAction();
    if (action != null && action.equals("viewPost")) {
        SemanticObject semObject = SemanticObject.createSemanticObject(request.getParameter("threadUri"));
        Thread thread = Thread.ClassMgr.getThread(semObject.getId(), website);
        if (null != request.getParameter("addView")) thread.setViewCount(thread.getViewCount() + 1);
        url.setParameter("threadUri", thread.getURI());
        urlRemovePost.setParameter("threadUri", thread.getURI());
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
	<div class="container">
            <div id="swbBlog">
		<div class="swbBlog-head">
                    <span><%=paramRequest.getLocaleString("lblComments")%></span>
                    <%
                        if (isTheAuthor || isforumAdmin) {
                            urlthread.setMode("editThread");
                    %>
                            <a class="btn" data-toggle="tooltip" data-placement="bottom" title="Editar tema" href="<%=urlthread.setParameter("threadUri", thread.getURI())%>">Editar</a>
                    <%
                        }
                        if (isTheAuthor || isforumAdmin) {
                            url.setAction("removePost");
                            url.setParameter("isthread", "1");
                            actionURL.setAction("removeThread");
                            actionURL.setParameter("forumUri", request.getParameter("forumUri"));
                    %>
                            <a class="btn" data-toggle="tooltip" data-placement="bottom" title="Eliminar tema" onclick="if (!confirm('<%=paramRequest.getLocaleString("remove")%> <%=thread.getTitle()%>?')) return false;" href="<%=actionURL.setParameter("threadUri", thread.getURI())%>">Eliminar</a>
                    <%
                        }
                    %>
                    <a class="btn" data-toggle="tooltip" data-placement="bottom" href="<%=paramRequest.getRenderUrl().setMode(SWBResourceURL.Mode_VIEW)%>" title="Volver a lista de temas">Regresar</a>
                </div>
                <% if (!flag.equals("")) {%>
                    <div class="alert alert-warning alert-dismissable">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                        <strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                    </div>
                <% }%>
		<div class="card card-entry">
                    <div class="card-header">
			<p class="card-entry-title"><%=thread.getTitle()%></p>
                        <p class="card-entry-dateuser">
			    <span><%=autor%></span>
                        </p>
                    </div>
                    <%
                        String text = thread.getBody() != null ? thread.getBody() : "";
                        text = SWBUtils.TEXT.replaceAll(text, "\n", "<br>");
                        text = SWBUtils.TEXT.parseHTML(text);
                        thread.setViewCount((thread.getViewCount() + 1));
                    %>
                    <div class="card-body">
			<p class="card-entry-cont"><%=text%></p>                
                    </div>
                    <div class="card-footer">
			<p class="card-entry-comments"><span><%=paramRequest.getLocaleString("responses")%></span><%=thread.getReplyCount()%></p>
                        <p class="card-entry-views"><span><%=paramRequest.getLocaleString("visites")%></span> <%=thread.getViewCount()%> </p>
                    </div>
		</div>
                <%
                    SWBFormMgr mgr = new SWBFormMgr(Post.frm_Post, thread.getSemanticObject(), null);
                    String photo = SWBPlatform.getContextPath() + "/swbadmin/images/defaultPhoto.png";
                    if ((user != null && user.isRegistered()) || acceptguesscomments) {
                        actionURL.setParameter("threadUri", thread.getURI());
                        actionURL.setAction("replyPost");
                        lang = user.getLanguage();
                %>
                        <div class="card card-add-comment">
                            <form class="form-horizontal" method="post" action="<%=actionURL%>" id="formSavePost">
                                <%=mgr.getFormHiddens()%>
                                <div class="card-header"> 
                                    <p><%=paramRequest.getLocaleString("lblLeaveMessage")%></p>
                                </div>
                                <div class="card-body">
                                    <textarea name='pstBody' id='pstBody' class="form-control"></textarea>
                                </div>
                                <%
                                    Boolean isCaptcha = request.getAttribute("isCaptcha") != null ? Boolean.parseBoolean(request.getAttribute("isCaptcha").toString()) : false;
                                %>
                                <% if (isCaptcha) {%>
                                    <div class="form-group" id="divcmnt_seccode">
                                        <label for="" class="col-lg-2 control-label"><%="Captcha *:"%></label>
                                        <div class="col-lg-4">
                                            <%="<img src=\"" + SWBPlatform.getContextPath() + "/swbadmin/jsp/securecode.jsp\" alt=\"\" id=\"imgseccode\" width=\"155\" height=\"65\" />"%>
                                        </div>
                                        <div class="col-lg-6">
                                            <%="<input class=\"form-control\" required type=\"text\" name=\"cmnt_seccode\" value=\"\"/>"%>
                                        </div>
                                    </div>
                                <% }%>
                                <div class="card-footer">
                                    <button type="submit" class="btn" id="saveForm"><%=paramRequest.getLocaleString("send")%></button>
                                </div>
                            </form>
                        </div>
                <%
                        out.print(SWBForum.getScriptValidator("saveForm", "formSavePost"));
                    }
                    Iterator<Post> itPost = SWBComparator.sortByCreated(thread.listPosts(), false);
                    if (itPost.hasNext()) {
                %>
                        <div class="card card-all-comments">
                            <div class="card-header">
                                <p><%=paramRequest.getLocaleString("responses")%></p>
                            </div>
                <%
                            while (itPost.hasNext()) {
                                Post post = itPost.next();
                                url.setParameter("postUri", post.getURI());
                                urlRemovePost.setParameter("postUri", post.getURI());
                                User userPost = null;
                                String postCreated = "";
                                String postCreator = "Anonimo";
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
                %>
                                <div class="card-body">
                                    <ul class="comment-piece">
                                        <li>
                                            <div class="card-entry-txt">
                                                <%=SWBUtils.TEXT.parseHTML(post.getBody())%>
                                            </div>
                                            <div class="card-entry-dateuser">
                                                <span><%=SWBUtils.TEXT.getTimeAgo(post.getUpdated(), user.getLanguage())%></span>
                                                <span><%=postCreator%></span>
                                            </div>
                                            <%
                                                urlRemovePost.setAction("removePost");
                                                urlthread.setMode("replyPost");
                                                urlthread.setParameter("postUri", post.getURI());
                                                urlthread.setParameter("threadUri", thread.getURI());
                                                if ((user != null && user.isRegistered()) || acceptguesscomments) {
                                            %>
                                                    <a class="btn" href="<%=urlthread%>"><%=paramRequest.getLocaleString("comment")%></a>
                                            <%
                                                }
                                                if (isTheAuthor || isforumAdmin) {
                                                    urlthread.setMode("editPost");
                                            %>
                                                    <a class="btn" href="<%=urlthread%>"><%=paramRequest.getLocaleString("edit")%></a>
                                            <%
                                                }
                                                if (isTheAuthor || isforumAdmin) {
                                                    url.setAction("removePost");
                                                    actionURL.setAction("removePost");
                                                    actionURL.setParameter("threadUri", thread.getURI());
                                            %>
                                                    <a class="btn" onclick="if (!confirm('<%=paramRequest.getLocaleString("remove")%> <%=paramRequest.getLocaleString("comment")%>?'))
                                                    return false;" href="<%=actionURL.setParameter("postUri", post.getURI())%>"><%=paramRequest.getLocaleString("remove")%></a>
                                            <%
                                                }
                                            %>
                                        </li>
                                    </ul>
                                </div>
                <%
                            }
                %>
                        </div>
                <%  
                    } 
                %>
            </div>
        </div>
	<!-- End viewPost -->
<% 
    } 
    else if (action != null && action.equals("removePost")) {
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
                                    <%=paramRequest.getLocaleString("threadData")%>
                                </h1>
                            </div>
                        </div>
                        <div class="panel-body">
                            <ul class="list-group">
                                <li class="list-group-item"><span class="fa fa-comments"></span><strong> <%=paramRequest.getLocaleString("thread")%>:</strong> <%=thread.getTitle()%></li>
                                <li class="list-group-item"><span class="fa fa-file"></span><strong> <%=paramRequest.getLocaleString("msg")%>:</strong> <%=thread.getBody()%></li>
                                <li class="list-group-item"><span class="fa fa-user"></span><strong> <%=paramRequest.getLocaleString("autor")%>:</strong> <%if (thread.getCreator() != null) {%><%=thread.getCreator().getFullName()%><%}%></li>
                                <li class="list-group-item">            
                                    <span class="fa fa-comments-o"></span><strong> <%=paramRequest.getLocaleString("noMsgs")%>:</strong>
                                    <%
                                        int postSize = 0;
                                        GenericIterator<Post> itPost = thread.listPosts();
                                        while (itPost.hasNext()) {
                                            Post post = itPost.next();
                                            postSize++;
                                        }
                                    %>
                                    <%=postSize%>
                                </li>
                            </ul>
                        </div>                                    
                        <div class="panel-footer text-right">
                            <form name="removeThread" action="<%=actionURL.toString()%>">
                                <input type="hidden" name="threadUri" value="<%=thread.getURI()%>">
                                <input type="hidden" name="forumUri" value="<%=request.getParameter("forumUri")%>">
                                <button type="button" class="btn btn-default" onClick="retorna(this.form);">
                                    <span class="fa fa-mail-reply"></span><%=paramRequest.getLocaleString("cancel")%>
                                </button>
                                <button type="submit" class="btn btn-success">
                                    <span class="fa fa-trash-o"></span><%=paramRequest.getLocaleString("remove")%>
                                </button>
                            </form>
                        </div>            
                    </div>
		</div>
            </div>
    <%
        } else {
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
                                    <span class="fa fa-trash-o"></span><%=paramRequest.getLocaleString("PostData")%>
                                </h1>
                            </div>
                        </div>
			<div class="panel-body">
                            <ul class="list-group">
				<li class="list-group-item"><span class="fa fa-comments"></span><strong> <%=paramRequest.getLocaleString("thread")%>:</strong> <%=post.getThread().getTitle()%></li>
                                <li class="list-group-item"><span class="fa fa-file"></span><strong> <%=paramRequest.getLocaleString("msg")%>:</strong> <%=post.getBody()%></li>
                                <li class="list-group-item"><span class="fa fa-user"></span><strong> <%=paramRequest.getLocaleString("autor")%>:</strong> <%if (post.getCreator() != null) {%><%=post.getCreator().getFullName()%><%}%></li>
                                <li class="list-group-item">
                                    <span class="fa fa-comments-o"></span>
                                    <strong> <%=paramRequest.getLocaleString("noResponse")%>:</strong>
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
                                    <span class="fa fa-mail-reply"></span><%=paramRequest.getLocaleString("cancel")%>
                                </button>
                                <button type="submit"class="btn btn-success">
                                    <span class="fa fa-trash-o"></span><%=paramRequest.getLocaleString("remove")%>
                                </button>
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
<%
	} else {
            url.setMode("addThread");
%>
            <div class="container">
		<div id="swbBlog">
                    <div class="swbBlog-head">
			<span>Foro</span>
			<%
                            if (!oforum.isOnlyAdminCreateThreads() || isforumAdmin) {
				if (user != null && user.isRegistered()) {
			%>
                                    <a class="btn" data-toggle="tooltip" data-placement="bottom" title="Agregar tema" href="<%=url%>">Nueva entrada</a>
			<%
				}
                            }
			%>
                    </div>
                    <%
                        if (!flag.equals("")) { 
                    %>
                            <div class="alert alert-warning alert-dismissable">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
				<strong>Aviso!</strong> <%=paramRequest.getLocaleString(flag)%>.
                            </div>
                    <%  
                        }
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
			Iterator<WebPage> itThreads = webpage.listChilds(null, null, false, null, null);
			while (itThreads.hasNext()) {
                            WebPage wp = itThreads.next();
                            if (wp != null && wp instanceof Thread) {
                                treeSet.add((Thread) wp);
                            }
			}
			Iterator<Thread> itThreads2 = request.getAttribute(SWBForum.ATT_THREADS) != null ? ((List<Thread>) request.getAttribute(SWBForum.ATT_THREADS)).iterator() : null;
                    %>

                    <%
                        int i = 0;
			while (itThreads2.hasNext()) {
                            String text = "";
                            Thread thread = itThreads2.next();
                            url.setParameter("threadUri", thread.getURI());
                            if (null != thread.getCreator()) autor = thread.getCreator().getFullName();
                    %>
                            <div class="card card-entry">  
                                <div class="card-header">
                                    <p class="card-entry-title"><%=thread.getTitle()%></p>
                                    <p class="card-entry-dateuser">
                                        <span><%=autor%></span>
                                        <span><%=SWBUtils.TEXT.getStrDate(thread.getCreated(), user.getLanguage())%></span>
                                    </p>
                                </div>
				<% 
                                    if (oforum.isShowThreadBody()) {
					text = null != thread.getBody() ? thread.getBody() : "";
                                        text = SWBUtils.TEXT.replaceAll(text, "\n", "<br>");
					text = SWBUtils.TEXT.parseHTML(text);
                                    }
				%>
                                    <div class="card-body">
					<p class="card-entry-cont"><%=text%></p>
                                        <div class="card-entry-last-comment">
                                            <p class="card-entry-last-title"><%=paramRequest.getLocaleString("lastcomment")%></p>
                                            <p class="card-entry-last-txt">
                                                <%
                                                    String date = "";
                                                    Post post = null;
                                                    Iterator<Post> itPost = SWBComparator.sortByCreated(thread.listPosts(), false);
                                                    if (itPost.hasNext()) {
                                                        post = itPost.next();
                                                        out.print(SWBUtils.TEXT.parseHTML(post.getBody()));
                                                        if (thread.getLastPostDate() != null) {
                                                            date = SWBUtils.TEXT.getTimeAgo(thread.getLastPostDate(), user.getLanguage());
                                                        }
                                                    } else {
                                                        out.print(paramRequest.getLocaleString("nocomments"));
                                                    }
                                                %>
                                            </p>
                                            <p class="card-entry-last-dateuser">
                                                <span><%=date%></span>
                                                <span><% out.print(null != post.getCreator() ? post.getCreator().getFullName() : "");%></span>
                                            </p>
                                        </div>
                                    </div>
                                    <div class="card-footer">
                                        <p class="card-entry-views"><span><%=paramRequest.getLocaleString("visites")%></span> <%=thread.getViewCount()%> </p>
                                        <p class="card-entry-comments"><span><%=paramRequest.getLocaleString("responses")%></span> <%=thread.getReplyCount()%> </p>
                                        <a class="btn" href="<%=url%>">Ver comentarios</a>
                                    </div>
                                </div>
                            <% } %>
                            <jsp:include page="/swbadmin/jsp/forum/pagination.jsp" flush="true"/>
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