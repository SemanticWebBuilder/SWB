<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!
    private static final int num=100;
%>
<%

            User useradmin = SWBContext.getAdminUser();
            if (useradmin == null)
            {
                response.sendError(403);
                return;
            }
%>
<%
            WebSite site = WebSite.ClassMgr.getWebSite("Ciudad_Digital");
            WebPage pagedemo = site.getWebPage("Int_Educacion");
            User user = site.getUserRepository().getUserByLogin("test");
            if (user == null)
            {
%>
El usuario test no existe
<%
                return;
            }

            for (int icomm = 1; icomm <= num; icomm++)
            {
                String id = "" + icomm;
                MicroSite ms = MicroSite.ClassMgr.createMicroSite(id, site);
                ms.setParent(pagedemo);
                ms.setTitle("Comunidad " + icomm);
                out.println(ms+":"+ms.getTitle()+"<br/>");
                ms.setDescription("Comunidad " + icomm);
                ms.setTags("Comunidad " + icomm);
                ms.setActive(Boolean.TRUE);
                ms.setCreated(new Date(System.currentTimeMillis()));
                ms.setCreator(user);
                String[] utils =
                {
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Blog",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Wiki",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Photos",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Videos",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Events",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Members",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Chat",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:News",
                    "http://www.Ciudad_Digital.swb#swbcomm_MicroSiteUtil:Twitter"
                };
                SemanticOntology ont = SWBPlatform.getSemanticMgr().getOntology();
                String type = null;
                if (null != type)
                {
                    
                    SemanticObject sotype = ont.getSemanticObject(type);
                    MicroSiteType mstype = null;
                    if (sotype.getGenericInstance() instanceof MicroSiteType)
                    {
                        mstype = (MicroSiteType) sotype.getGenericInstance();
                        ms.setType(mstype);
                    }
                }

                ms.setPrivate(false);
                ms.setModerate(false);


                Template template = site.getTemplate("8");
                TemplateRef tmpRef = site.createTemplateRef();
                tmpRef.setTemplate(template);
                tmpRef.setActive(Boolean.TRUE);
                tmpRef.setInherit(TemplateRef.INHERIT_ACTUALANDCHILDS);
                tmpRef.setValid(Boolean.TRUE);
                tmpRef.setPriority(3);
                ms.addTemplateRef(tmpRef);


                if (null != utils && utils.length > 0)
                {

                    for (int i = 0; i < utils.length; i++)
                    {
                        //System.out.println("i:"+i+", wputil:"+utils[i]);
                        GenericObject sowpu = ont.getGenericObject(utils[i]);

                        //System.out.println("tipo: "+sowpu.getSemanticObject().getSemanticClass());


                        if (sowpu != null && sowpu instanceof MicroSiteUtil)
                        {
                            MicroSiteUtil msu = (MicroSiteUtil) sowpu;
                            MicroSiteWebPageUtil mswpu = MicroSiteWebPageUtil.ClassMgr.createMicroSiteWebPageUtil(ms.getId() + "_" + msu.getId(), site);

                            mswpu.setTitle(msu.getTitle());


                            mswpu.setMicroSite(ms);
                            mswpu.setMicroSiteUtil(msu);

                            mswpu.setParent(ms);
                            mswpu.setActive(Boolean.TRUE);

                            //System.out.println("MicroSiteUtil:"+utils[i]);
                        }
                    }
                }

                // Suscribo al creador de la nueva comunidad a esta.

                Member member = Member.ClassMgr.createMember(pagedemo.getWebSite());
                member.setAccessLevel(Member.LEVEL_OWNER); //Member.LEVEL_EDIT
                member.setUser(user);
                member.setMicroSite(ms);


                // blogs


                Blog blog = Blog.ClassMgr.createBlog(site);
                blog.setTitle("Blog " + icomm + "_" + ms.getId());
                blog.setDescription("Blog " + icomm + "_" + ms.getId());
                WebPage blogwp=ms.getWebSite().getWebPage(ms.getId()+"_"+"Blog");
                blog.setWebPage(blogwp);
                out.println(blog+":"+blog.getTitle()+"<br/>");
                blog.setCreated(new Date(System.currentTimeMillis()));
                blog.setCreator(user);
                for (int j = 1; j <= num; j++)
                {
                    PostElement element = PostElement.ClassMgr.createPostElement(site);
                    blog.addPostElement(element);
                    element.setContent("Contenido de prueba");
                    element.setDescription("Contenido de prueba");
                    element.setTitle("Contenido de prueba");
                    element.setCreated(new Date(System.currentTimeMillis()));
                    element.setCreator(user);
                    element.setUpdated(new Date(System.currentTimeMillis()));
                }

                // Eventos
                for (int j = 1; j <= num; j++)
                {
                    EventElement element = EventElement.ClassMgr.createEventElement(site);
                    WebPage eventwp=ms.getWebSite().getWebPage(ms.getId()+"_"+"Events");
                    element.setEventWebPage(eventwp);
                    element.setEventImage("Quiero_viajar_al_Municipio.jpg");
                    element.setEventThumbnail("Quiero_viajar_al_Municipio.jpg");
                    element.setCreated(new Date(System.currentTimeMillis()));
                    element.setCreator(user);
                    element.setDescription("Contenido de prueba");
                    element.setTitle("Contenido de prueba");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(new Date(System.currentTimeMillis()));
                    cal.add(cal.MONTH, 1);
                    element.setStartDate(cal.getTime());
                    element.setEndDate(cal.getTime());
                    element.setPlace("contenido de prueba");
                    element.setAudienceType("Todos");
                    out.println(element+":"+element.getTitle()+"<br/>");
                }
                // noticias


                for (int j = 1; j <= num; j++)
                {
                    NewsElement element = NewsElement.ClassMgr.createNewsElement(site);
                    WebPage newswp=ms.getWebSite().getWebPage(ms.getId()+"_"+"News");
                    element.setNewsWebPage(newswp);
                    element.setCreated(new Date(System.currentTimeMillis()));
                    element.setCreator(user);
                    element.setDescription("Contenido de prueba");
                    element.setTitle("Contenido de prueba");
                    element.setNewsImage("Quiero_viajar_al_Municipio.jpg");
                    element.setNewsThumbnail("Quiero_viajar_al_Municipio.jpg");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(new Date(System.currentTimeMillis()));
                    cal.add(cal.MONTH, 1);
                    element.setAuthor("Contenido de prueba");
                    element.setCitation("Contenido de prueba");
                    element.setFullText("Contenido de prueba");
                    out.println(element+":"+element.getTitle()+"<br/>");
                }

                // Fotos

                for (int j = 1; j <= num; j++)
                {
                    PhotoElement element = PhotoElement.ClassMgr.createPhotoElement(site);
                    WebPage photowp=ms.getWebSite().getWebPage(ms.getId()+"_"+"Photos");
                    element.setPhotoWebPage(photowp);
                    element.setCreated(new Date(System.currentTimeMillis()));
                    element.setCreator(user);
                    element.setDescription("Contenido de prueba");
                    element.setTitle("Contenido de prueba");
                    element.setImageURL("Quiero_viajar_al_Municipio.jpg");
                    element.setPhotoThumbnail("Quiero_viajar_al_Municipio.jpg");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(new Date(System.currentTimeMillis()));
                    cal.add(cal.MONTH, 1);
                    element.setTags("Contenido de prueba");
                    out.println(element+":"+element.getTitle()+"<br/>");
                }
                // videos
                for (int j = 1; j <= num; j++)
                {
                    VideoElement element = VideoElement.ClassMgr.createVideoElement(site);
                    WebPage videowp=ms.getWebSite().getWebPage(ms.getId()+"_"+"Videos");
                    element.setWebPage(videowp);
                    element.setCreated(new Date(System.currentTimeMillis()));
                    element.setCreator(user);
                    element.setDescription("Contenido de prueba");
                    element.setTitle("Contenido de prueba");
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.setTime(new Date(System.currentTimeMillis()));
                    cal.add(cal.MONTH, 1);
                    element.setTags("Contenido de prueba");
                    out.println(element+":"+element.getTitle()+"<br/>");
                }

            }




%>
Fin de creación