<%@page contentType="text/html"%>
<%@page import="java.text.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar el video: '+title+'?'))
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
            String suscribeURL = paramRequest.getActionUrl().setParameter("act", "subscribe").toString();
            String unsuscribeURL = paramRequest.getActionUrl().setParameter("act", "unsubscribe").toString();
            String urlAddVideo = paramRequest.getRenderUrl().setParameter("act", "add").toString();
            ArrayList<VideoElement> elements = new ArrayList();
            int elementos = 0;
            Iterator<VideoElement> it = VideoElement.ClassMgr.listVideoElementByWebPage(wpage, wpage.getWebSite());
            it = SWBComparator.sortByCreated(it, false);
            while (it.hasNext())
            {
                VideoElement element = it.next();
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
            if (member.canAdd())
            {
        %>
        <a class="adminTool" href="<%=urlAddVideo%>">Agregar video</a>
        <%
            }
        %>


    </div>
    <%
            if (elements.size() == 0)
            {
    %>
    <p>No hay videos registrados en la comunidad</p>
    <%            }
            int iElement = 0;
            for (VideoElement video : elements)
            {


                SWBResourceURL viewUrl = paramRequest.getRenderUrl().setParameter("act", "detail").setParameter("uri", video.getURI());
                if (video.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        String rank = df.format(video.getRank());
                        String editEventURL = paramRequest.getRenderUrl().setParameter("act", "edit").setParameter("uri", video.getURI()).toString();
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", video.getEncodedURI());
                        String removeurl = "javascript:validateremove('" + removeUrl + "','" + video.getTitle() + "','" + video.getURI() + "')";
                        String title = "Sin título";
                        if (video.getTitle() != null)
                        {
                            title = video.getTitle().replace("'", "\\'");
                        }
                        String description = "Sin descripción";
                        if (video.getDescription() != null)
                        {
                            description = video.getDescription().replace("'", "\\'");
                        }
                        String postAuthor = "Usuario dado de baja";
                        if (video.getCreator() != null)
                        {
                            postAuthor = video.getCreator().getFirstName();
                        }

    %>
    <div class="noticia">
        <img src="<%=video.getPreview()%>" alt="<%=title%>"/>
        <div class="noticiaTexto">
            <h2>
                <script type="text/javascript">
                    <!--
                    document.write('<%=title%>');
                    -->
                </script></h2>
            <p>&nbsp;<br/>Por: <%=postAuthor%><br/><%=dateFormat.format(video.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(video.getCreated(), user.getLanguage())%></p>
            <p>
                <script type="text/javascript">
                    <!--
                    document.write('<%=description%>');
                    -->
                </script>
                | <a href="<%=viewUrl.toString(true)%>">Ver más</a>
                <%
                        if (video.canModify(member))
                        {
                %>
                | <a href="<%=editEventURL%>">Editar</a>
                <%
                        }
                %>
                <%
                        if (video.canModify(member) || isAdministrator)
                        {
                %>
                | <a href="<%=removeurl%>">Eliminar</a>
                <%
                        }
                %>
            </p>            
            <p class="stats">
            	Puntuación: <%=rank%><br/>
                <%=video.getViews()%> vistas
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
    <ul class="miContenido">        <%
            SWBResourceURL urla = paramRequest.getActionUrl();
            if (member.canView())
            {
                if (!wputil.isSubscribed(member))
                {
                    urla.setParameter("act", "subscribe");
        %>
        <li><a href="<%=urla%>">Suscribirse a videos de comunidad</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a videos</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?video=" + java.net.URLEncoder.encode(wpage.getURI());
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al canal de videos de la comunidad</a></li>
    </ul>
    <%
            if (!wputil.isSubscribed(member))
            {
    %>
    <br/><br/><p><span class="tituloRojo">NOTA: </span>Si se suscribe a los videos de la comunidad, recibirá una notificación por correo electrónico cuando algún miembro agrege o modifique algún video.</p>
    <%            }
    %>

</div>
