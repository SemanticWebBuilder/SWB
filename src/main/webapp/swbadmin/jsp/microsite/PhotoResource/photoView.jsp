<%@page contentType="text/html"%>
<%@page import="org.semanticwb.platform.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%@page import="org.semanticwb.model.Resource" %>
<%@page import="java.text.*,org.semanticwb.portal.SWBFormMgr"%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar la foto: '+title+'?'))
        {            
            window.location.href=url;
        }
    }
</script>

<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>
<%
            java.text.SimpleDateFormat dateFormat;


            String lang = "es";
            Locale locale = new Locale(lang);
            dateFormat = new java.text.SimpleDateFormat("dd-MMM-yyyy", locale);
            String[] months =
            {
                "Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
            };
            java.text.DateFormatSymbols fs = dateFormat.getDateFormatSymbols();
            fs.setShortMonths(months);
            dateFormat.setDateFormatSymbols(fs);

            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");

            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
            Resource base = paramRequest.getResourceBase();
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
            Member member = Member.getMember(user, wpage);
            boolean isAdministrator = false;
            if (user != null)
            {
                GenericIterator<UserGroup> groups = user.listUserGroups();
                while (groups.hasNext())
                {
                    UserGroup group = groups.next();
                    if (group != null && group.getId().equals("admin"))
                    {
                        isAdministrator = true;
                        break;
                    }
                }
            }
            String urlAddPhoto = paramRequest.getRenderUrl().setParameter("act", "add").toString();
            ArrayList<PhotoElement> elements = new ArrayList();
            int elementos = 0;
            Iterator<PhotoElement> it = PhotoElement.ClassMgr.listPhotoElementByPhotoWebPage(wpage, wpage.getWebSite());
            it = SWBComparator.sortByCreated(it, false);
            while (it.hasNext())
            {
                PhotoElement event = it.next();
                if (event.canView(member))
                {
                    elements.add(event);
                    elementos++;
                }
            }
            int paginas = elementos / ELEMENETS_BY_PAGE;
            if (elementos % ELEMENETS_BY_PAGE != 0)
            {
                paginas++;
            }
            int inicio = 0;
            int fin = ELEMENETS_BY_PAGE;
            int ipage = 1;
            if (request.getParameter("ipage") != null)
            {
                try
                {
                    ipage = Integer.parseInt(request.getParameter("ipage"));
                    inicio = (ipage * ELEMENETS_BY_PAGE) - ELEMENETS_BY_PAGE;
                    fin = (ipage * ELEMENETS_BY_PAGE);
                }
                catch (NumberFormatException nfe)
                {
                    ipage = 1;
                }
            }
            if (ipage < 1 || ipage > paginas)
            {
                ipage = 1;
            }
            if (inicio < 0)
            {
                inicio = 0;
            }
            if (fin < 0)
            {
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin > elementos)
            {
                fin = elementos;
            }
            if (inicio > fin)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            if (fin - inicio > ELEMENETS_BY_PAGE)
            {
                inicio = 0;
                fin = ELEMENETS_BY_PAGE;
            }
            inicio++;
%>
<script type="text/javascript">
    dojo.require("dojox.image.Lightbox");
    dojo.require("dojo.parser");

</script>

<div class="columnaIzquierda">
    <!-- paginacion -->
    <%
            if (paginas > 1)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %>
            <strong>
                <%                    }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                    }
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->
    <div class="adminTools">
        <%
            if (member.canAdd())
            {
        %>
        <a class="adminTool" href="<%=urlAddPhoto%>">Agregar foto</a>
        <%
            }
        %>


    </div>
    <%
            if (elements.size() == 0)
            {
    %>
    <p>No hay fotos registradas en la comunidad</p>
    <%            }
            int iElement = 0;
            for (PhotoElement photo : elements)
            {
                if (photo.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        String postAuthor = "Usuario dado de baja";
                        if (photo.getCreator() != null)
                        {
                            postAuthor = photo.getCreator().getFirstName();
                        }

                        SWBResourceURL urlDetail = paramRequest.getRenderUrl();
                        urlDetail.setParameter("act", "detail");
                        urlDetail.setParameter("uri", photo.getURI());
                        SWBResourceURL viewurl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", photo.getURI());
                        String rank = df.format(photo.getRank());
                        String editEventURL = paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", photo.getURI()).toString(true);
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", photo.getEncodedURI());
                        String removeurl = "javascript:validateremove('" + removeUrl + "','" + photo.getTitle() + "')";

                        String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/PhotoResource/sinfoto.png";
                        String path = photo.getWorkPath();
                        if (photo.getPhotoThumbnail() != null)
                        {
                            int pos = photo.getPhotoThumbnail().lastIndexOf("/");
                            if (pos != -1)
                            {
                                String sphoto = photo.getPhotoThumbnail().substring(pos + 1);
                                photo.setPhotoThumbnail(sphoto);
                            }
                            pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + photo.getPhotoThumbnail();
                        }

                        String imgPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/PhotoResource/sinfoto.png";
                        if (photo.getImageURL() != null)
                        {
                            int pos = photo.getImageURL().lastIndexOf("/");
                            if (pos != -1)
                            {
                                String sphoto = photo.getImageURL().substring(pos + 1);
                                photo.setImageURL(sphoto);
                            }
                            imgPhoto = SWBPortal.getWebWorkPath() + path + "/" + photo.getImageURL();
                        }
                        String title = "";
                        if (photo.getTitle() != null)
                        {
                            title = photo.getTitle().replace("'", "\\'");
                        }
                        String description = "";
                        if (photo.getDescription() != null)
                        {
                            description = photo.getDescription().replace("'", "\\'");
                        }

    %>
    <div class="noticia">
        <script type="text/javascript">
            dojo.addOnLoad(function(){
                var props={href:'<%=imgPhoto%>'};
                var a=new dojox.image.Lightbox(props,"aimg_<%=iElement + base.getId()%>");
                a.startup();
            });
        </script>
        <a href="<%=imgPhoto%>" id="aimg_<%=iElement + base.getId()%>" title="<%= photo.getTitle()%>" >
            <img id="img_<%=iElement + base.getId()%>" src="<%=pathPhoto%>" alt="<%= photo.getTitle()%>" width="150" height="150" />
        </a>
        <div class="noticiaTexto">
            <h2>
                <script type="text/javascript">
                    <!--
                    document.write('<%=title%>');
                    -->
                </script>
            </h2>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(photo.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(photo.getCreated(), user.getLanguage())%></p>
            <p>
                <script type="text/javascript">
                    <!--
                    document.write('<%=description%>');
                    -->
                </script>
                | <a href="<%=viewurl.toString(true)%>">Ver más</a>
                <%
                        if (photo.canModify(member))
                        {
                %>
                | <a href="<%=editEventURL%>">Editar</a>
                <%
                        }
                %>
                <%
                        if (photo.canModify(member) || isAdministrator)
                        {
                %>
                | <a href="<%=removeurl%>">Eliminar</a>
                <%
                        }
                %>
            </p>
            <p class="stats">
            	Puntuación: <%=rank%><br/>
                <%=photo.getViews()%> vistas
            </p>
        </div>
    </div>
    <%
                    }
                }
            }
    %>
    <!-- paginacion -->
    <%
            if (paginas > 1)
            {
    %>
    <div class="paginacion">


        <%
                String nextURL = "#";
                String previusURL = "#";
                if (ipage < paginas)
                {
                    nextURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage + 1);
                }
                if (ipage > 1)
                {
                    previusURL = paramRequest.getWebPage().getUrl() + "?ipage=" + (ipage - 1);
                }
                if (ipage > 1)
                {
        %>
        <a href="<%=previusURL%>"><img src="<%=cssPath%>pageArrowLeft.gif" alt="anterior"/></a>
            <%
                }
                for (int i = 1; i <= paginas; i++)
                {
            %>
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>"><%
                    if (i == ipage)
                    {
            %>
            <strong>
                <%                    }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                    }
            %></a>
        <%
                }
        %>


        <%
                if (ipage != paginas)
                {
        %>
        <a href="<%=nextURL%>"><img src="<%=cssPath%>pageArrowRight.gif" alt="siguiente"/></a>
            <%
                }
            %>
    </div>
    <%
            }
    %>
    <!-- fin paginacion -->

</div>
<div class="columnaCentro">
    <%
            if (paginas > 1)
            {
    %>
    <br/><br/>
    <%            }
    %>
    <ul class="miContenido">
        <%
            SWBResourceURL urla = paramRequest.getActionUrl();
            if (member.canView())
            {
                if (!wputil.isSubscribed(member))
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a las fotos de la comunidad</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a fotos</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?photo=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de fotos de la comunidad</a></li>
    </ul>
    <%
            if (!wputil.isSubscribed(member))
            {
    %>
    <br/><br/><p><span class="tituloRojo">NOTA: </span>Si se suscribe a las fotos de la comunidad, recibirá una notificación por correo electrónico cuando algún miembro agrege o modifique alguna foto.</p>
    <%            }
    %>

</div>
