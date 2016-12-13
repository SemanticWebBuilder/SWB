<%@page import="org.semanticwb.portal.api.*,org.semanticwb.portal.resources.sem.news.*,org.w3c.dom.*,org.semanticwb.portal.community.*,java.util.*,org.semanticwb.model.WebPage,org.semanticwb.platform.SemanticObject"%><%@page import="org.semanticwb.model.*,org.semanticwb.SWBUtils,org.semanticwb.SWBPortal,org.semanticwb.SWBPlatform,org.semanticwb.platform.*,org.semanticwb.portal.api.SWBResourceURL"%><%!
    private List<SWBNewContent> getNews(String uri, User user, SWBNews swbNews)
    {
        List<SWBNewContent> news = new ArrayList<SWBNewContent>();
        GenericIterator<Resource> resources = null;
        if (swbNews.getCollection() != null && swbNews.getCollection().getResourceCollectionType().getResourceClassName().equals(SWBNewContent.class.getCanonicalName()))
        {
            if (swbNews.getCategory() == null)
            {
                resources = swbNews.getCollection().listResources();
            }
            else
            {
                boolean isCategoryOfCallection = false;
                GenericIterator<ResourceCollectionCategory> categories = swbNews.getCollection().listCategories();
                while (categories.hasNext())
                {
                    ResourceCollectionCategory category = categories.next();
                    if (category.getURI().equals(swbNews.getCategory().getURI()))
                    {
                        isCategoryOfCallection = true;
                        break;
                    }
                }
                if (isCategoryOfCallection)
                {
                    resources = swbNews.getCategory().listResources();
                }
                else
                {
                    resources = swbNews.getCollection().listResources();
                }
            }
        }
        if (resources != null)
        {
            while (resources.hasNext())
            {
                Resource resource = resources.next();
                if (resource.isActive() && !resource.isDeleted() && user.haveAccess(resource))
                {
                    SWBNewContent object = (SWBNewContent) resource.getResourceData().createGenericInstance();
                    if (uri == null)
                    {
                        try
                        {
                            object.setResourceBase(resource);
                            news.add(object);
                        }
                        catch (Exception e)
                        {
                        }
                    }
                    else
                    {
                        if (uri.equals(resource.getURI()) || uri.equals(resource.getId()))
                        {

                            try
                            {
                                object.setResourceBase(resource);
                                news.add(object);
                            }
                            catch (Exception e)
                            {
                            }
                        }
                    }

                }
            }
        }
        return news;
    }
%><%
       String title = "";
            SWBParamRequest paramRequest = (SWBParamRequest) request.getAttribute("paramRequest");
            SWBNews news = (SWBNews) request.getAttribute("this");
            List<SWBNewContent> newslist = getNews(null, paramRequest.getUser(), news);
            User user=paramRequest.getUser();
            String uri = request.getParameter("uri");

            StringTokenizer st = new StringTokenizer(request.getRequestURI(), "/");
            if (st.countTokens() >= 4)
            {
                ArrayList<String> values = new ArrayList<String>();
                while (st.hasMoreTokens())
                {
                    values.add(st.nextToken());
                }
                uri = values.get(3);
                if ("_rid".equals(uri) && values.size()>=6)
                {
                    uri = values.get(5);
                }                
            }

            if (uri != null)
            {
                for (int icontent = 0; icontent < newslist.size(); icontent++)
                {
                    SWBNewContent temp = newslist.get(icontent);
                    if (temp.getResourceBase().getURI().equals(uri) || temp.getResourceBase().getId().equals(uri))
                    {
                        
                        title = "::: "+SWBUtils.TEXT.encodeExtendedCharacters(temp.getResourceBase().getDisplayTitle(paramRequest.getUser().getLanguage()));
                    }
                }
            }%><%=title%>