<%@page contentType="text/html"%>
<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>

<%!
    private Member getMember(User user, MicroSite site)
    {
        if (site != null)
        {
            Iterator<Member> it = Member.ClassMgr.listMemberByUser(user, site.getWebSite());
            while (it.hasNext())
            {
                Member mem = it.next();
                if (mem.getMicroSite().equals(site))
                {
                    return mem;
                }
            }
        }
        return null;
    }
%>
<%

            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            User user = paramRequest.getUser();
            WebPage wp = paramRequest.getWebPage();
            SWBResourceURL urle = paramRequest.getRenderUrl();
            urle.setParameter("act", "edit");
            MicroSite site = MicroSite.getMicroSite(paramRequest.getWebPage());
            Member member = getMember(user, site);
            if (!(wp instanceof MicroSite))
            {
                return;
            }
            String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";
            String path = wp.getWorkPath();

            if (site.getPhoto() != null)
            {
                int pos = site.getPhoto().lastIndexOf("/");
                if (pos != -1)
                {
                    String photo = site.getPhoto().substring(pos + 1);
                    site.setPhoto(photo);
                }
                pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + site.getPhoto();

            }
            String creator = "Usuario dado de baja";
            if (site.getCreator() != null)
            {
                creator = site.getCreator().getFullName();
            }
%>

<div class="columnaIzquierda">
    <h2>Resumen</h2>
    <div class="resumenText">
        <%
            if (site.getTags() != null && site.getTags().trim().length() > 0 && !site.getTags().equals("null"))
            {
        %>
        <p><span class="itemTitle">Palabras Clave:</span> <%=site.getTags()%></p>
        <%
            }
        %>
        <p><span class="itemTitle">Creador:</span> <%=creator%></p>
        <p><span class="itemTitle">Creada:</span> <%=SWBUtils.TEXT.getTimeAgo(site.getCreated(), user.getLanguage())%></p>
        <p><span class="itemTitle">Modificada:</span> <%=SWBUtils.TEXT.getTimeAgo(site.getUpdated(), user.getLanguage())%></p>



    </div>
    <h2>Descripción</h2>
    <%
            if (site.getDescription() != null && !site.getDescription().trim().equals(""))
            {
    %>
    <p><%=site.getDescription()%></p>
    <%
            }
            else
            {
    %>
    <p>Sin descripción</p>
    <%            }
    %>

    <h2>Contenidos</h2>

    <ul class="listaContenidos">
        <%            {
                int entradas = 0;
                if (wp.getWebSite().getWebPage(wp.getId() + "_Blog") != null)
                {
                    Iterator<Blog> blogs = Blog.ClassMgr.listBlogByWebPage(wp.getWebSite().getWebPage(wp.getId() + "_Blog"));
                    if (blogs.hasNext())
                    {
                        Blog blog = blogs.next();
                        if (blog != null)
                        {
                            Iterator<PostElement> it = blog.listPostElements();
                            while (it.hasNext())
                            {
                                PostElement element = it.next();                                
                                if (member!=null && element!=null && element.canView(member))
                                {
                                    entradas++;
                                }
                                
                            }
        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Blog").getUrl()%>"><img src="<%=cssPath%>icoBlog.png" alt="blog"/><span class="elemento">Blog:</span> <%=entradas%> entradas</a> <a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Blog").getUrl()%>" class="verMas">ver</a></li>
                <%
                        }
                    }
                }
            }

                %>


        <%            {
                int eventos = 0;
                if (wp.getWebSite().getWebPage(wp.getId() + "_Events") != null)
                {
                    Iterator<EventElement> elements = EventElement.ClassMgr.listEventElementByEventWebPage(wp.getWebSite().getWebPage(wp.getId() + "_Events"));
                    while (elements.hasNext())
                    {
                        EventElement element = elements.next();
                        if (member!=null && element!=null && element.canView(member))
                        {
                            eventos++;
                        }
                    }

        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Events").getUrl()%>"><img src="<%=cssPath%>icoEventos.png" alt="eventos"/><span class="elemento">Eventos:</span> <%=eventos%> entradas</a><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Events").getUrl()%>" class="verMas">ver</a></li>
                <%

                }
            }

                %>


        <%            {
                int fotos = 0;
                if (wp.getWebSite().getWebPage(wp.getId() + "_Photos") != null)
                {
                    Iterator<PhotoElement> elements = PhotoElement.ClassMgr.listPhotoElementByPhotoWebPage(wp.getWebSite().getWebPage(wp.getId() + "_Photos"));
                    while (elements.hasNext())
                    {
                        PhotoElement element = elements.next();
                        if (member!=null && element!=null && element.canView(member))
                        {
                            fotos++;
                        }
                    }

        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Photos").getUrl()%>"><img src="<%=cssPath%>icoFotos.png" alt="fotos"/><span class="elemento">Fotos</span> <%=fotos%> entradas</a><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Photos").getUrl()%>" class="verMas">ver</a></li>
                <%


                }
            }

                %>


        <%
            if (wp.getWebSite().getWebPage(wp.getId() + "_Members") != null)
            {
                int miembros = 0;
                if (wp instanceof MicroSite)
                {
                    MicroSite ms = (MicroSite) wp;
                    if (ms != null)
                    {
                        GenericIterator<Member> members = ms.listMembers();
                        while (members.hasNext())
                        {
                            members.next();
                            miembros++;
                        }

        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Members").getUrl()%>"><img src="<%=cssPath%>icoUsuario.png" alt="miembros"/><span class="elemento">Miembros:</span> <%=miembros%> entradas</a><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Members").getUrl()%>" class="verMas">ver</a></li>
                <%

                    }
                }
            }

                %>


        <%            {
                int noticias = 0;
                if (wp.getWebSite().getWebPage(wp.getId() + "_News") != null)
                {
                    Iterator<NewsElement> elements = NewsElement.ClassMgr.listNewsElementByNewsWebPage(wp.getWebSite().getWebPage(wp.getId() + "_News"));
                    while (elements.hasNext())
                    {
                        NewsElement element = elements.next();
                        if (member!=null && element!=null && element.canView(member))
                        {
                            noticias++;
                        }
                    }

        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_News").getUrl()%>"><img src="<%=cssPath%>icoNoticias.png" alt="noticias"/><span class="elemento">Noticias:</span> <%=noticias%> entradas</a><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_News").getUrl()%>" class="verMas">ver</a></li>
                <%


                }
            }

                %>


        <%            {
                int videos = 0;
                if (wp.getWebSite().getWebPage(wp.getId() + "_Videos") != null)
                {
                    Iterator<VideoElement> elements = VideoElement.ClassMgr.listVideoElementByWebPage(wp.getWebSite().getWebPage(wp.getId() + "_Videos"));
                    while (elements.hasNext())
                    {
                        VideoElement element = elements.next();
                        if (member!=null && element!=null && element.canView(member))
                        {
                            videos++;
                        }
                    }

        %>
        <li><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Videos").getUrl()%>"><img src="<%=cssPath%>icoVideo.png" alt="videos"/><span class="elemento">Videos:</span> <%=videos%> entradas</a><a href="<%=wp.getWebSite().getWebPage(wp.getId() + "_Videos").getUrl()%>" class="verMas">ver</a></li>
                <%


                }
            }

                %>


    </ul>
    <%
            if (!user.isRegistered())
            {
    %>
    <p><span class="tituloRojo">NOTA: </span>Debe estar registrado y estar suscrito a la comunidad para poder agregar contenido a la misma.</p>
    <%            }
    %>
</div>

<div class="columnaCentro">
    <h2 class="blogTitle"><%=site.getTitle()%></h2>
    <p><img src="<%=pathPhoto%>" alt="Imagen comunidad"  /></p>
        <%
            if (null != member && member.getAccessLevel() == Member.LEVEL_OWNER && user.isRegistered())
            {

        %>
    <p><a href="<%=urle%>">[Cambiar imagen]</a></p>

    <%
            }

    %>
    <ul class="miContenido">
        <%

            SWBResourceURL urla = paramRequest.getActionUrl();
            if (user.isRegistered())
            {
                if (member == null)
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a esta comunidad</a></li>
        <%
                }
                else if (null != member && member.getAccessLevel() != Member.LEVEL_OWNER && user.isRegistered())
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a comunidad</a></li>
        <%
                }

            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?comm=" + java.net.URLEncoder.encode(wp.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS </a></li>
        <%

        %>

    </ul>
    <%
            if (!(null != member && member.getAccessLevel() == Member.LEVEL_OWNER && user.isRegistered()))
            {
    %>
    <br/><p><span class="tituloRojo">NOTA: </span>Sólo el dueño de la comunidad puede cambiar la información básica de la misma.</p>
    <%            }
    %>
</div>
