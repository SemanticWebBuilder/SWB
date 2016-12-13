<jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>
<%@page import="com.google.gdata.client.Query"%>
<%@page import="com.google.gdata.client.blogger.BloggerService"%>
<%@page import="com.google.gdata.data.Entry"%>
<%@page import="com.google.gdata.data.Feed"%>
<%@page import="com.google.gdata.data.Person"%>
<%@page import="com.google.gdata.data.PlainTextConstruct"%>
<%@page import="com.google.gdata.data.TextContent"%>
<%@page import="com.google.gdata.util.ServiceException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.URL"%>

<%!
 private static final String METAFEED_URL = "http://www.blogger.com/feeds/default/blogs";
%>

<%
    System.out.println("blogger-1");
    String FEED_URI_BASE = "http://www.blogger.com/feeds";
    String POSTS_FEED_URI_SUFFIX = "/posts/default";
    String COMMENTS_FEED_URI_SUFFIX = "/comments/default";
    String userName = "george24Infotec@gmail.com";
    String userPassword = "george24";
    BloggerService myService = new BloggerService("semWebBuilder");
    try {
        System.out.println("blogger-2");
        myService.setUserCredentials(userName, userPassword);
        System.out.println("blogger-3");
        String blogId = getBlogId(myService);
        createBlog(myService);
        //String feedUri = FEED_URI_BASE + "/" + blogId;
        System.out.println("blogger-4");
        printUserBlogs(myService);
        System.out.println("blogger-5");
    } catch (ServiceException se) {
      se.printStackTrace();
    } catch (IOException ioe) {
      ioe.printStackTrace();
    }


%>

<%!
    private static boolean createBlog(BloggerService myService) throws ServiceException, IOException {
        myService.

        return true;
    }


    /**
   * Parses the metafeed to get the blog ID for the authenticated user's default
   * blog.
   *
   * @param myService An authenticated GoogleService object.
   * @return A String representation of the blog's ID.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  private static String getBlogId(BloggerService myService)
      throws ServiceException, IOException {
    // Get the metafeed
    final URL feedUrl = new URL(METAFEED_URL);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // If the user has a blog then return the id (which comes after 'blog-')
    if (resultFeed.getEntries().size() > 0) {
      Entry entry = resultFeed.getEntries().get(0);
      return entry.getId().split("blog-")[1];
    }
    throw new IOException("User has no blogs!");
  }

   /**
   * Prints a list of all the user's blogs.
   *
   * @param myService An authenticated GoogleService object.
   * @throws ServiceException If the service is unable to handle the request.
   * @throws IOException If the URL is malformed.
   */
  public static void printUserBlogs(BloggerService myService) throws ServiceException, IOException {

    // Request the feed
    final URL feedUrl = new URL(METAFEED_URL);
    Feed resultFeed = myService.getFeed(feedUrl, Feed.class);

    // Print the results
    System.out.println(resultFeed.getTitle().getPlainText());
    for (int i = 0; i < resultFeed.getEntries().size(); i++) {
      Entry entry = resultFeed.getEntries().get(i);
      System.out.println("\t" + entry.getTitle().getPlainText());
    }
    System.out.println();
  }
%>