<%@page import="org.w3c.dom.*,org.semanticwb.portal.community.*,java.util.*,org.semanticwb.model.WebPage,org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.*,org.semanticwb.SWBUtils,org.semanticwb.SWBPortal,org.semanticwb.SWBPlatform,org.semanticwb.platform.*,org.semanticwb.portal.api.SWBResourceURL"%><%!
    private Element addAtribute(Element ele, String name, String value)
    {
        Document doc = ele.getOwnerDocument();
        Element n = doc.createElement(name);
        ele.appendChild(n);
        n.appendChild(doc.createTextNode(value));
        return n;
    }
%><%!    private static final int MAX_ITEMS = 10;

    public String getTitle(WebPage webpage)
    {

        if (webpage instanceof MicroSite)
        {
            String title = webpage.getTitle();
            return title;
        }
        else
        {
            webpage = webpage.getParent();
            if (webpage != null && webpage instanceof MicroSite)
            {
                String title = webpage.getTitle();
                return title;
            }
        }
        return "";
    }
%><%

            if (request.getAttribute("webpage") != null)
            {
                if (request.getAttribute("user") == null || request.getAttribute("webpage") == null)
                {
                    return;
                }
                int count = 0;
                WebSite site = ((WebPage) request.getAttribute("webpage")).getWebSite();
                User owner = (User) request.getAttribute("user");
                User user = owner;
                if (request.getParameter("user") != null)
                {
                    SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                    user = (User) semObj.createGenericInstance();
                }
                if (user.getURI() == null)
                {
                    return;
                }
                Iterator<MicroSiteElement> elements = MicroSiteElement.ClassMgr.listMicroSiteElementByCreator(user, site);
                elements = SWBComparator.sortByCreated(elements, false);
                while (elements.hasNext())
                {
                    Object obj = elements.next();
                    if (obj != null && obj instanceof PostElement && ((PostElement) obj).getVisibility() == MicroSiteElement.VIS_ALL)
                    {
                        count++;

                    }
                }
                String userURI = java.net.URLEncoder.encode(user.getURI());
                String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp";
                String siteid = site.getId();
%><li><a class="rss" href="<%=pageUri%>?user=<%=userURI%>&site=<%=siteid%>" >Artículos publicados (<%=count%>)</a></li><%
            }
            else
            {
                if (request.getParameter("user") != null && request.getParameter("site") != null)
                {
                    WebSite site = WebSite.ClassMgr.getWebSite(request.getParameter("site"));
                    SemanticObject semObj = SemanticObject.createSemanticObject(request.getParameter("user"));
                    User user = (User) semObj.createGenericInstance();
                    if (user != null && site != null)
                    {
                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        addAtribute(channel, "title", "Artículos publicados de " + user.getFullName());
                        addAtribute(channel, "link", site.getWebPage("perfil").getUrl() + "?user=" + user.getEncodedURI());
                        addAtribute(channel, "description", "Artículos publicados de " + user.getFullName());

                        int i = 0;

                        Iterator<MicroSiteElement> elements = MicroSiteElement.ClassMgr.listMicroSiteElementByCreator(user, site);
                        elements = SWBComparator.sortByCreated(elements, false);
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj != null && obj instanceof PostElement)
                            {
                                PostElement element = (PostElement) obj;
                                if (element != null)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);
                                    if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                    {
                                        addAtribute(item, "title", element.getTitle());
                                        String url = element.getURL();
                                        url = SWBUtils.TEXT.replaceAllIgnoreCase(url, "&amp;", "&");
                                        addAtribute(item, "link", url);
                                        addAtribute(item, "description", element.getDescription());
                                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                        i++;
                                        if (i == MAX_ITEMS)
                                        {
                                            break;
                                        }
                                    }

                                }
                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));
                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("event") != null)
                {
                    String eventURI = request.getParameter("event");
                    SemanticObject eventObj = SemanticObject.createSemanticObject(eventURI);
                    if (eventObj != null)
                    {
                        WebPage eventwebpage = new WebPage(eventObj);


                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        String title = getTitle(eventwebpage);
                        addAtribute(channel, "title", "Eventos de la comunidad " + title);
                        String url = eventwebpage.getUrl();
                        url = SWBUtils.TEXT.replaceAllIgnoreCase(url, "&amp;", "&");
                        addAtribute(channel, "link", url);
                        addAtribute(channel, "description", "Eventos de la comunidad " + title);



                        Iterator<EventElement> elements = EventElement.ClassMgr.listEventElementByEventWebPage(eventwebpage);
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj instanceof EventElement)
                            {
                                EventElement element = (EventElement) obj;
                                if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);
                                    addAtribute(item, "title", element.getTitle());

                                    String url2 = element.getURL();
                                    url2 = SWBUtils.TEXT.replaceAllIgnoreCase(url2, "&amp;", "&");
                                    addAtribute(item, "link", url2);
                                    addAtribute(item, "description", element.getDescription());
                                    addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                    addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                    i++;
                                    if (i == MAX_ITEMS)
                                    {
                                        break;
                                    }

                                }

                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("photo") != null)
                {
                    String photoURI = request.getParameter("photo");
                    SemanticObject photoObj = SemanticObject.createSemanticObject(photoURI);
                    if (photoObj != null)
                    {
                        WebPage photowebpage = new WebPage(photoObj);


                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        String title = getTitle(photowebpage);
                        addAtribute(channel, "title", "Fotos de la comunidad " + title);
                        String url2 = photowebpage.getUrl();
                        url2 = SWBUtils.TEXT.replaceAllIgnoreCase(url2, "&amp;", "&");
                        addAtribute(channel, "link", url2);
                        addAtribute(channel, "description", "Fotos de la comunidad " + title);



                        Iterator<PhotoElement> elements = PhotoElement.ClassMgr.listPhotoElementByPhotoWebPage(photowebpage);
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj instanceof PhotoElement)
                            {
                                PhotoElement element = (PhotoElement) obj;
                                if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);

                                    addAtribute(item, "title", element.getTitle());
                                    String url3 = element.getURL();
                                    url3 = SWBUtils.TEXT.replaceAllIgnoreCase(url3, "&amp;", "&");
                                    addAtribute(item, "link", url3);
                                    addAtribute(item, "description", element.getDescription());
                                    addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                    addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                    i++;
                                    if (i == MAX_ITEMS)
                                    {
                                        break;
                                    }
                                }

                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("news") != null)
                {
                    String newsUri = request.getParameter("news");
                    SemanticObject newsObj = SemanticObject.createSemanticObject(newsUri);
                    if (newsObj != null)
                    {
                        WebPage newswebpage = new WebPage(newsObj);


                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        String title = getTitle(newswebpage);
                        addAtribute(channel, "title", "Noticias de la comunidad " + title);
                        String url3 = newswebpage.getUrl();
                        url3 = SWBUtils.TEXT.replaceAllIgnoreCase(url3, "&amp;", "&");
                        addAtribute(channel, "link", url3);
                        addAtribute(channel, "description", "Noticias de la comunidad " + title);



                        Iterator<NewsElement> elements = NewsElement.ClassMgr.listNewsElementByNewsWebPage(newswebpage);
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj instanceof NewsElement)
                            {
                                NewsElement element = (NewsElement) obj;
                                if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);

                                    addAtribute(item, "title", element.getTitle());
                                    String url4 = element.getURL();
                                    url4 = SWBUtils.TEXT.replaceAllIgnoreCase(url4, "&amp;", "&");
                                    addAtribute(item, "link", url4);
                                    addAtribute(item, "description", element.getDescription());
                                    addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                    addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                    i++;
                                    if (i == MAX_ITEMS)
                                    {
                                        break;
                                    }
                                }

                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("video") != null)
                {
                    String videoUri = request.getParameter("video");
                    SemanticObject videoObj = SemanticObject.createSemanticObject(videoUri);
                    if (videoObj != null)
                    {
                        WebPage videowebpage = new WebPage(videoObj);


                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        String title = getTitle(videowebpage);
                        addAtribute(channel, "title", "Videos de la comunidad " + title);
                        String url4 = videowebpage.getUrl();
                        url4 = SWBUtils.TEXT.replaceAllIgnoreCase(url4, "&amp;", "&");
                        addAtribute(channel, "link", url4);
                        addAtribute(channel, "description", "Videos de la comunidad " + title);



                        Iterator<VideoElement> elements = VideoElement.ClassMgr.listVideoElementByWebPage(videowebpage);
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj instanceof VideoElement)
                            {
                                VideoElement element = (VideoElement) obj;
                                if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);

                                    addAtribute(item, "title", element.getTitle());
                                    String url5 = element.getURL();
                                    url5 = SWBUtils.TEXT.replaceAllIgnoreCase(url5, "&amp;", "&");
                                    addAtribute(item, "link", url5);
                                    addAtribute(item, "description", element.getDescription());
                                    addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                    addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                    i++;
                                    if (i == MAX_ITEMS)
                                    {
                                        break;
                                    }
                                }

                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("comm") != null)
                {
                    String commURI = request.getParameter("comm");
                    SemanticObject commObj = SemanticObject.createSemanticObject(commURI);
                    if (commObj != null)
                    {
                        org.semanticwb.portal.community.MicroSite commWebpage = (org.semanticwb.portal.community.MicroSite) commObj.createGenericInstance();


                        response.setContentType("application/rss+xml;charset=utf-8");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        String title = getTitle(commWebpage);

                        addAtribute(channel, "title", "Comunidad " + title);
                        String url5 = commWebpage.getUrl();
                        url5 = SWBUtils.TEXT.replaceAllIgnoreCase(url5, "&amp;", "&");
                        addAtribute(channel, "link", url5);
                        addAtribute(channel, "description", title);

                        Iterator<WebPage> childs = commWebpage.listVisibleChilds("es");
                        while (childs.hasNext())
                        {
                            WebPage child = childs.next();
                            {
                                
                                Iterator<Blog> blogs = Blog.ClassMgr.listBlogByWebPage(child);
                                while (blogs.hasNext())
                                {
                                    Blog blog = blogs.next();
                                    Iterator<PostElement> elements = PostElement.ClassMgr.listPostElementByBlog(blog);
                                    elements = SWBComparator.sortByCreated(elements, false);
                                    int i = 0;
                                    while (elements.hasNext())
                                    {
                                        PostElement element = elements.next();
                                        if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                        {
                                            Element item = doc.createElement("item");
                                            channel.appendChild(item);

                                            addAtribute(item, "title", element.getTitle());
                                            String url6 = element.getURL();
                                            url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                                            addAtribute(item, "link", url6);
                                            addAtribute(item, "description", element.getDescription());
                                            addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                            addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                            i++;
                                            if (i == MAX_ITEMS)
                                            {
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                            {
                                Iterator<EventElement> elements = EventElement.ClassMgr.listEventElementByEventWebPage(child);
                                elements = SWBComparator.sortByCreated(elements, false);
                                int i = 0;
                                while (elements.hasNext())
                                {
                                    EventElement element = elements.next();
                                    if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                    {
                                        Element item = doc.createElement("item");
                                        channel.appendChild(item);

                                        addAtribute(item, "title", element.getTitle());
                                        String url6 = element.getURL();
                                        url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                                        addAtribute(item, "link", url6);
                                        addAtribute(item, "description", element.getDescription());
                                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                        i++;
                                        if (i == MAX_ITEMS)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            {
                                Iterator<PhotoElement> elements = PhotoElement.ClassMgr.listPhotoElementByPhotoWebPage(child);
                                elements = SWBComparator.sortByCreated(elements, false);
                                int i = 0;
                                while (elements.hasNext())
                                {
                                    PhotoElement element = elements.next();
                                    if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                    {
                                        Element item = doc.createElement("item");
                                        channel.appendChild(item);

                                        addAtribute(item, "title", element.getTitle());
                                        String url6 = element.getURL();
                                        url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                                        addAtribute(item, "link", url6);
                                        addAtribute(item, "description", element.getDescription());
                                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                        i++;
                                        if (i == MAX_ITEMS)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            {
                                Iterator<NewsElement> elements = NewsElement.ClassMgr.listNewsElementByNewsWebPage(child);
                                elements = SWBComparator.sortByCreated(elements, false);
                                int i = 0;
                                while (elements.hasNext())
                                {
                                    NewsElement element = elements.next();
                                    if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                    {
                                        Element item = doc.createElement("item");
                                        channel.appendChild(item);

                                        addAtribute(item, "title", element.getTitle());
                                        String url6 = element.getURL();
                                        url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                                        addAtribute(item, "link", url6);
                                        addAtribute(item, "description", element.getDescription());
                                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                        i++;
                                        if (i == MAX_ITEMS)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            {
                                Iterator<VideoElement> elements = VideoElement.ClassMgr.listVideoElementByWebPage(child);
                                elements = SWBComparator.sortByCreated(elements, false);
                                int i = 0;
                                while (elements.hasNext())
                                {
                                    VideoElement element = elements.next();
                                    if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                    {
                                        Element item = doc.createElement("item");
                                        channel.appendChild(item);

                                        addAtribute(item, "title", element.getTitle());
                                        String url6 = element.getURL();
                                        url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                                        addAtribute(item, "link", url6);
                                        addAtribute(item, "description", element.getDescription());
                                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                        i++;
                                        if (i == MAX_ITEMS)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        /*Iterator<MicroSiteElement> elements = MicroSiteElement.ClassMgr.lis(commWebpage.getWebSite());
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                        MicroSiteElement element = elements.next();
                        if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                        {
                        Element item = doc.createElement("item");
                        channel.appendChild(item);

                        addAtribute(item, "title", element.getTitle());
                        String url6 = element.getURL();
                        url6 = SWBUtils.TEXT.replaceAllIgnoreCase(url6, "&amp;", "&");
                        addAtribute(item, "link", url6);
                        addAtribute(item, "description", element.getDescription());
                        addAtribute(item, "pubDate", element.getCreated().toGMTString());
                        addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                        i++;
                        if (i == MAX_ITEMS)
                        {
                        break;
                        }
                        }
                        }*/

                        out.write(new String(org.semanticwb.SWBUtils.XML.domToXml(doc).getBytes("iso-8859-1"), "utf-8"));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else if (request.getParameter("blog") != null)
                {
                    String blogURI = request.getParameter("blog");
                    SemanticObject objBlog = SemanticObject.createSemanticObject(blogURI);
                    if (objBlog != null)
                    {
                        Blog blog = new Blog(objBlog);
                        response.setContentType("application/rss+xml");
                        Document doc = org.semanticwb.SWBUtils.XML.getNewDocument();
                        Element rss = doc.createElement("rss");
                        rss.setAttribute("version", "2.0");
                        doc.appendChild(rss);

                        Element channel = doc.createElement("channel");
                        rss.appendChild(channel);
                        addAtribute(channel, "title", blog.getTitle());
                        addAtribute(channel, "link", blog.getWebPage().getUrl());
                        addAtribute(channel, "description", blog.getDescription());



                        Iterator<PostElement> elements = blog.listPostElements();
                        elements = SWBComparator.sortByCreated(elements, false);
                        int i = 0;
                        while (elements.hasNext())
                        {
                            Object obj = elements.next();
                            if (obj instanceof PostElement)
                            {
                                PostElement element = (PostElement) obj;
                                if (element.getVisibility() == MicroSiteElement.VIS_ALL)
                                {
                                    Element item = doc.createElement("item");
                                    channel.appendChild(item);
                                    addAtribute(item, "title", element.getTitle());
                                    String url = element.getURL();
                                    url = SWBUtils.TEXT.replaceAllIgnoreCase(url, "&amp;", "&");
                                    addAtribute(item, "link", url);
                                    addAtribute(item, "description", element.getDescription());
                                    addAtribute(item, "pubDate", element.getCreated().toGMTString());
                                    addAtribute(item, "guid", "cd_digital" + element.getURL() + "#rid" + element.getId());
                                    i++;
                                    if (i == MAX_ITEMS)
                                    {
                                        break;
                                    }
                                }

                            }
                        }
                        out.write(org.semanticwb.SWBUtils.XML.domToXml(doc));

                    }
                    else
                    {
                        response.sendError(404);
                    }
                }
                else
                {
                    response.sendError(404);
                }
            }
%>