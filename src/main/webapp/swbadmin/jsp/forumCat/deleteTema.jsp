<%@page import="org.semanticwb.SWBUtils"%>
<%@page import="java.text.DateFormatSymbols"%><%@page import="java.net.*"%><%@page import="org.semanticwb.model.*"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.text.DecimalFormat"%><%@page import="org.semanticwb.portal.api.SWBResourceURL"%><%@page import="org.semanticwb.portal.api.SWBParamRequest"%><%@page import="org.semanticwb.resources.sem.forumcat.*"%>
<%@page import="org.semanticwb.portal.SWBFormMgr"%><%@page import="org.semanticwb.SWBPortal"%><%@page import="org.semanticwb.portal.SWBFormButton"%><%@page import="org.semanticwb.platform.SemanticObject"%>
<%@page import="java.util.Iterator"%><%@page import="java.text.SimpleDateFormat"%><%@page import="java.util.Locale"%><%@page import="java.util.Date"%>
<%@page import="java.util.HashMap"%><%@page import="java.util.ArrayList"%><%@page import="org.semanticwb.platform.SemanticClass"%>
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
            boolean isAdmin = false;
            Role role = user.getUserRepository().getRole("adminForum");
            if (role != null && user.hasRole(role))
            {
                isAdmin = true;
            }
            if (isAdmin)
            {
                String idTema = request.getParameter("idTema");
                if (idTema != null && !idTema.trim().isEmpty())
                {
                    WebSite site = paramRequest.getWebPage().getWebSite();
                    if (WebPage.ClassMgr.hasWebPage(idTema, site))
                    {
                        WebPage pageToDelete = WebPage.ClassMgr.getWebPage(idTema, site);
                        if (pageToDelete != null)
                        {
                            //boolean canDelete = pageToDelete.getCreator() != null && pageToDelete.getCreator().getId().equals(user.getId());
                            //if (canDelete)
                            {
                                Resource base = paramRequest.getResourceBase();
                                SemanticObject semanticBase = base.getResourceData();
                                String pid = semanticBase.getProperty(SWBForumCatResource.forumCat_idCatPage, paramRequest.getWebPage().getId());
                                WebPage wpp = paramRequest.getWebPage().getWebSite().getWebPage(pid);
                                if (wpp == null)
                                {
%>
<p>La página de inicio de temas no se encontró, avise al administrador del sitio.</p>
<%                            }
                                else
                                {
                                    if (wpp.getId().equals(pageToDelete.getParent().getId()))
                                    {
                                        String title = pageToDelete.getTitle();
                                        pageToDelete.setDeleted(true);
%>
<p>El tema con título <b><%=title%></b> ha sido borrada.</p>
<%
                                    }
                                }
                            }

                        }
                        else
                        {
%>
<p>No se encontro la página a borrar</p>
<%                                                    }
                    }
                    else
                    {
%>
No se encontró el tema a borrar.
<%                                            }
                }
                else
                {
%>
<p>No se pudo dar de alta el tema, razon: titulo no especificado.
    <%                                }
                }
                else
                {
    %>
<p>No tiene permisos para esta operación</p>
<%                            }
%>


