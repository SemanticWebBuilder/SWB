<%@page import="java.io.IOException"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="org.semanticwb.portal.api.SWBResourceURLImp"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="org.semanticwb.base.util.SWBMail"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.semanticwb.Logger"%>
<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.text.DateFormatSymbols"%><%@page import="java.net.*"%><%@page import="org.semanticwb.model.*"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.DecimalFormat"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.portal.api.SWBParamRequest"%><%@page import="org.semanticwb.resources.sem.forumcat.*"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.portal.SWBFormButton"%><%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Locale"%><%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%><%@page import="java.util.ArrayList"%><%@page import="org.semanticwb.platform.SemanticClass"%>
<%!
    public void notifica(User user,HttpServletRequest request,SWBParamRequest paramRequest,String titulo,WebPage newTema) throws MalformedURLException,IOException
    {
        Role role = user.getUserRepository().getRole("adminForum");

        if (role != null)
        {
            
            ArrayList<InternetAddress> aAddress = new ArrayList<InternetAddress>();
            Iterator<User> users = user.getUserRepository().listUsers();
            while (users.hasNext())
            {
                User userSite = users.next();
                if (userSite.getEmail() != null && userSite.hasRole(role))
                {
                    InternetAddress address1 = new InternetAddress();
                    address1.setAddress(userSite.getEmail());
                    
                    aAddress.add(address1);

                }
            }
            SWBMail swbMail = new SWBMail();
            swbMail.setAddress(aAddress);
            swbMail.setContentType("text/html");
            String port = "";
            if (request.getServerPort() != 80)
            {
                port = ":" + request.getServerPort();
            }

            SWBResourceURLImp imp = new SWBResourceURLImp(request, paramRequest.getResourceBase(), newTema, SWBResourceURL.UrlType_RENDER);
            URL urilocal = new URL(request.getScheme() + "://" + request.getServerName() + port + imp.toString());
            swbMail.setData("Se creó el tema con el nombre " + titulo + " en el sitio: " + urilocal.toString());
            swbMail.setSubject("Tema de foro creado con titulo " + newTema.getTitle());
            swbMail.setFromEmail(SWBPlatform.getEnv("af/adminEmail"));
            swbMail.setHostName(SWBPlatform.getEnv("swb/smtpServer"));
            SWBUtils.EMAIL.sendBGEmail(swbMail);
            aAddress = new ArrayList<InternetAddress>();
            if (user.getEmail() != null)
            {
                InternetAddress address1 = new InternetAddress();
                address1.setAddress(user.getEmail());
                aAddress.add(address1);
            }
            swbMail = new SWBMail();
            swbMail.setAddress(aAddress);
            swbMail.setContentType("text/html");
            port = "";
            if (request.getServerPort() != 80)
            {
                port = ":" + request.getServerPort();
            }

            imp = new SWBResourceURLImp(request, paramRequest.getResourceBase(), newTema, SWBResourceURL.UrlType_RENDER);
            urilocal = new URL(request.getScheme() + "://" + request.getServerName() + port + imp.toString());
            swbMail.setData("Se creó el tema con el nombre " + titulo + " en el sitio: " + urilocal.toString());
            swbMail.setSubject("Tema de foro creado con titulo " + newTema.getTitle());
            swbMail.setFromEmail(SWBPlatform.getEnv("af/adminEmail"));
            swbMail.setHostName(SWBPlatform.getEnv("swb/smtpServer"));
            SWBUtils.EMAIL.sendBGEmail(swbMail);
        }
    }
%>
<%
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String url = paramRequest.getWebPage().getUrl();


%>
<p><strong><a href="<%=url%>">Página de inicio de los foros</a></strong></p>
<%
            User user = paramRequest.getUser();
            if (!user.isSigned())
            {
                return;
            }
            String titulo = request.getParameter("title");
            if (titulo != null && !titulo.trim().isEmpty())
            {
                WebSite site = paramRequest.getWebPage().getWebSite();
                String id = SWBUtils.TEXT.replaceSpecialCharacters(titulo, true);
                id = SWBUtils.TEXT.encodeBase64(id);
                Logger log = SWBUtils.getLogger(SWBForumCatResource.class);

                if (id.indexOf("%") != -1)
                {
                    id = id.replace('%', 'A');
                }
                if (id.indexOf("\r") != -1)
                {
                    id = id.replace('\r', 'A');
                }
                if (id.indexOf("\n") != -1)
                {
                    id = id.replace('\n', 'A');
                }
                if (id.indexOf("=") != -1)
                {
                    id = id.replace('=', 'O');
                }
                log.error("id: " + id);


                if (!WebPage.ClassMgr.hasWebPage(id, site))
                {
                    Resource base = paramRequest.getResourceBase();
                    SemanticObject semanticBase = base.getResourceData();
                    String pid = semanticBase.getProperty(SWBForumCatResource.forumCat_idCatPage, paramRequest.getWebPage().getId());
                    WebPage wpp = paramRequest.getWebPage().getWebSite().getWebPage(pid);
                    if (wpp != null)
                    {
                        WebPage newTema = WebPage.ClassMgr.createWebPage(id, site);
                        newTema.setCreator(user);
                        newTema.setActive(true);
                        String desc = request.getParameter("desc");
                        if (desc != null && !desc.trim().isEmpty())
                        {
                            newTema.setDescription(desc);
                        }
                        newTema.setTitle(titulo);
                        newTema.setParent(wpp);
                        notifica(user, request, paramRequest, titulo, newTema);



%>
<p>El tema con título "<%=titulo%>" fue creada correctamente.</p>
<%
                    }
                    else
                    {
%>
<p>No se encontró la página de inicio de temas, favor de reportarlo con su admistrador de sitio.</p>
<%                                                    }


                }
                else
                {
%>
Ya existe un tema con ese nombre, intente otro título.
<%                                            }
            }
            else
            {
%>
<p>No se pudo dar de alta el tema, razon: titulo no especificado.
    <%                                }

    %>

