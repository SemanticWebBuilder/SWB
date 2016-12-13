<%@page contentType="text/html"%>
<%@page import="java.util.Calendar, java.util.GregorianCalendar, java.text.SimpleDateFormat, org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar la noticia: '+title+'?'))
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
            String urladd = paramRequest.getRenderUrl().setParameter("act", "add").toString();
            boolean canadd = member.canAdd();
            String suscribeURL = paramRequest.getActionUrl().setParameter("act", "subcribe").toString();
            String unSuscribeURL = paramRequest.getActionUrl().setParameter("act", "unsubcribe").toString();

            ArrayList<NewsElement> elements = new ArrayList();
            int elementos = 0;
            Iterator<NewsElement> it = NewsElement.ClassMgr.listNewsElementByNewsWebPage(wpage, wpage.getWebSite());
            it = SWBComparator.sortByCreated(it, false);
            while (it.hasNext())
            {
                NewsElement element = it.next();
                if (element.canView(member))
                {
                    elements.add(element);
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
            if (canadd)
            {
        %>
        <a class="adminTool" href="<%=urladd%>">Agregar noticia</a>
        <%
            }
        %>
    </div>
    <%
            if (elements.size() == 0)
            {
    %>
    <p>No hay noticias registradas en la comunidad</p>
    <%            }
            int iElement = 0;
            for (NewsElement anew : elements)
            {
                if (anew.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", anew.getURI());
                        String rank = df.format(anew.getRank());
                        String editEventURL = paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", anew.getURI()).toString();
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", anew.getEncodedURI());
                        String removeurl = "javascript:validateremove('" + removeUrl + "','" + anew.getTitle() + "')";

                        String pathPhoto = SWBPortal.getContextPath() + "/swbadmin/jsp/microsite/MembershipResource/userIMG.jpg";
                        String path = anew.getWorkPath();
                        if (anew.getNewsThumbnail() != null)
                        {
                            int pos = anew.getNewsThumbnail().lastIndexOf("/");
                            if (pos != -1)
                            {
                                String sphoto = anew.getNewsThumbnail().substring(pos + 1);
                                anew.setNewsThumbnail(sphoto);
                            }
                            pathPhoto = SWBPortal.getWebWorkPath() + path + "/" + anew.getNewsThumbnail();
                        }
                        String title = "";
                        if (anew.getTitle() != null)
                        {
                            title = anew.getTitle().replace("'", "\\'");
                        }
                        String description = "";
                        if (anew.getDescription() != null)
                        {
                            description = anew.getDescription().replace("'", "\\'");
                        }
    %>
    <div class="noticia">
        <img src="<%= pathPhoto%>" alt="<%= anew.getTitle()%>" width="150" height="150"/>
        <div class="noticiaTexto">
            <h2>
                <script type="text/javascript">
                    <!--
                    document.write('<%=title%>');
                    -->
                </script></h2>

            <p>&nbsp;<br/>Por: <%=anew.getAuthor()%><br/><%=dateFormat.format(anew.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(anew.getCreated(), user.getLanguage())%></p>
            <p>
                <script type="text/javascript">
                    <!--
                    document.write('<%=description%>');
                    -->
                </script>

                | <a href="<%=viewUrl.toString(true)%>">Ver más</a>
                <%
                        if (anew.canModify(member))
                        {
                %>
                | <a href="<%=editEventURL%>">Editar</a>
                <%
                        }
                %>
                <%
                        if (anew.canModify(member) || isAdministrator)
                        {
                %>
                | <a href="<%=removeurl%>">Eliminar</a>
                <%
                        }
                %>
            </p>
            <p class="stats">
            	Puntuación: <%=rank%><br/>
                <%=anew.getViews()%> vistas
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
                <%                        }
                %>
                <%=i%>
                <%
                    if (i == ipage)
                    {
                %>
            </strong>
            <%                        }
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
        <li><a href="<%=urla%>">Suscribirse a noticias de la comunidad</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a noticias</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?news=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de noticias de la comunidad</a></li>
    </ul>
    <%
            if (!wputil.isSubscribed(member))
            {
    %>
    <br/><br/><p><span class="tituloRojo">NOTA: </span>Si se suscribe a las noticias de la comunidad, recibirá una notificación por correo electrónico cuando algún miembro agrege o modifique alguna noticia.</p>
    <%            }
    %>


</div>

