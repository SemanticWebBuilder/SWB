<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.*,org.semanticwb.platform.*,java.text.*,org.semanticwb.portal.api.*,org.semanticwb.portal.community.*,org.semanticwb.*,org.semanticwb.model.*,java.util.*"%>
<%!    private static final int ELEMENETS_BY_PAGE = 5;
%>
<script type="text/javascript">
    function validateremove(url, title)
    {
        if(confirm('¿Esta seguro de borrar la entrada: '+title+'?'))
        {            
            window.location.href=url;
        }
    }
</script>


<%

            java.text.SimpleDateFormat dateFormat;
            SimpleDateFormat iso8601dateFormat;
            java.text.DecimalFormat df = new java.text.DecimalFormat("#0.0#");


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
            String defaultFormat = "d 'de' MMMM  'del' yyyy 'a las' HH:mm";
            iso8601dateFormat = new SimpleDateFormat(defaultFormat, locale);


            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            User user = paramRequest.getUser();
            WebPage wpage = paramRequest.getWebPage();
            MicroSiteWebPageUtil wputil = MicroSiteWebPageUtil.getMicroSiteWebPageUtil(wpage);
            Blog blog = (Blog) request.getAttribute("blog");

            String createdBlog = iso8601dateFormat.format(blog.getCreated());
            String updatedBlog = iso8601dateFormat.format(blog.getUpdated());
            Member member = Member.getMember(user, wpage);
            SWBResourceURL urlAdd = paramRequest.getRenderUrl();
            urlAdd.setParameter("act", "add");
            String titleBlog = blog.getTitle().replace("'", "\\'");
            String descriptionBlog = blog.getDescription().replace("'", "\\'");
            SWBResourceURL urleditar = paramRequest.getRenderUrl();
            urleditar.setParameter("act", "edit");
            urleditar.setParameter("mode", "editblog");
            boolean editarblog = false;
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
            if (member.getAccessLevel() == member.LEVEL_OWNER)
            {
                editarblog = true;
            }
            boolean canadd = false;
            canadd = member.canAdd();
            String cssPath = SWBPortal.getWebWorkPath() + "/models/" + paramRequest.getWebPage().getWebSiteId() + "/css/images/";
%>
<div class="columnaIzquierda">
    <%
            ArrayList<PostElement> elements = new ArrayList();
            Iterator<PostElement> posts = blog.listPostElements();
            posts = SWBComparator.sortByCreated(posts, false);
            while (posts.hasNext())
            {
                PostElement post = posts.next();
                if (post.canView(member))
                {
                    elements.add(post);
                }
            }
            int paginas = elements.size() / ELEMENETS_BY_PAGE;
            if (elements.size() % ELEMENETS_BY_PAGE != 0)
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
            if (fin > elements.size())
            {
                fin = elements.size();
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
        <a href="<%=wpage.getUrl()%>?ipage=<%=i%>">
            <%
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
            %>
        </a>
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


    <div class="adminTools">
        <%
            if (canadd)
            {
        %>
        <a class="adminTool" href="<%=urlAdd%>">Agregar entrada</a>
        <%
            }
        %>

        <%
            if (editarblog)
            {
        %>
        <a class="adminTool" href="<%=urleditar%>">Administrar</a>
        <%
            }
        %>

    </div>

    <h2 class="hidden">
        <script type="text/javascript">
            <!--
            document.write('<%=titleBlog%>');
            -->
        </script>

    </h2>
    <%

            if (elements.size() == 0)
            {
    %>
    <p>No hay entradas para el blog</p>
    <%            }

            int iElement = 0;
            for (PostElement post : elements)
            {
                if (post.canView(member))
                {
                    iElement++;
                    if (iElement > fin)
                    {
                        break;
                    }
                    if (iElement >= inicio && iElement <= fin)
                    {
                        String description = post.getDescription().replace("'", "\\'");
                        String title = post.getTitle().replace("'", "\\'");
                        if (description == null)
                        {
                            description = "";
                        }

                        SWBResourceURL urlEditPost = paramRequest.getRenderUrl();
                        urlEditPost.setParameter("act", "edit");
                        urlEditPost.setParameter("uri", post.getURI());
                        urlEditPost.setParameter("mode", "editpost");
                        String postAuthor = "Usuario dado de baja";
                        if (post.getCreator() != null)
                        {
                            postAuthor = post.getCreator().getFirstName();
                        }
                        SWBResourceURL urlDetail = paramRequest.getRenderUrl();
                        urlDetail.setParameter("act", "detail");
                        urlDetail.setParameter("uri", post.getURI());
                        SWBResourceURL removeUrl = paramRequest.getActionUrl();
                        removeUrl.setParameter("act", "remove");
                        removeUrl.setParameter("uri", post.getEncodedURI());
                        String removeurl = "javascript:validateremove('" + removeUrl + "','" + post.getTitle() + "')";
                        boolean canEditPost = post.canModify(member);
                        String rank = df.format(post.getRank());
                        String visited = String.valueOf(post.getViews());
                        int comments = 0;
                        GenericIterator it = post.listComments();
                        while (it.hasNext())
                        {
                            it.next();
                            comments++;
                        }

    %>
    <div class="blogEntry">
        <h3 class="blogEntryTitle"><%=title%></h3>
        <%
                        if (canEditPost)
                        {
        %>
        <a class="editar" href="<%=urlEditPost%>">[editar]</a>
        <%
                        }
        %>

        <%
                        if (canEditPost || isAdministrator)
                        {
        %>
        <a class="editar" href="<%=removeurl%>">[eliminar]</a>
        <%
                        }
        %>

        <p><span class="itemTitle">Por:</span> <%=postAuthor%><br/>
            <span class="itemTitle">Creada:</span> <%=dateFormat.format(post.getCreated())%> - <%=SWBUtils.TEXT.getTimeAgo(post.getCreated(), user.getLanguage())%><br/>
            <span class="itemTitle">Modificada:</span> <%=dateFormat.format(post.getUpdated())%> - <%=SWBUtils.TEXT.getTimeAgo(post.getUpdated(), user.getLanguage())%><br/>
            <span class="itemTitle">Calificación:</span> <%=rank%><br/>
            <span class="itemTitle">Visitada:</span> <%=visited%> veces
        </p>
        <p>
            <script type="text/javascript">
                <!--
                document.write('<%=description%>');
                -->
            </script>

        </p>
        <p><a href="<%=urlDetail.toString(true)%>">Leer entrada completa</a>&nbsp;<span class="notificaciones"><%=comments%> comentarios</span> </p>

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
    <h2 class="blogTitle">
    <script type="text/javascript">
            <!--
            document.write('<%=titleBlog%>');
            -->
        </script></h2>
    <p> <script type="text/javascript">
            <!--
            document.write('<%=descriptionBlog%>');
            -->
        </script> </p>
    <p> Creado el: <%=createdBlog%> </p>
    <%
            if (!updatedBlog.equals(createdBlog))
            {
    %>
    <p> Actualizado el: <%=updatedBlog%> </p>
    <%
            }
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
        <li><a href="<%=urla%>">Suscribirse a blog</a></li>
        <%
                }
                else
                {
                    urla.setParameter("act", "unsubscribe");
        %>
        <li><a href="<%=urla%>">Cancelar suscripción a blog</a></li>
        <%
                }
            }
            String pageUri = SWBPortal.getContextPath() +"/swbadmin/jsp/microsite/rss/rss.jsp?blog=" + blog.getEncodedURI();
        %>
        <li><a class="rss" href="<%=pageUri%>">Suscribirse via RSS al blog de la comunidad</a></li>
    </ul>
    <%
            if (!editarblog)
            {
    %>
    <br/><br/><p><span class="tituloRojo">NOTA: </span>Sólo el dueño de la comunidad puede cambiar el título y descripción del blog.</p>

    <%            }
            if (!wputil.isSubscribed(member))
            {
                if (editarblog)
                {
    %>
    <br/><br/>
    <%                }
    %>
    <p><span class="tituloRojo">NOTA: </span>Si se suscribe al blog de la comunidad, recibirá una notificación por correo electrónico cuando algún miembro agrege o modifique alguna entrada.</p>
    <%            }
    %>

</div>


