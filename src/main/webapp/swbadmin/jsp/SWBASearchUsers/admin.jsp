<%@page import="org.semanticwb.SWBPlatform"%>
<%@page import="java.util.Collections"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.Iterator"%><%@page import="javax.naming.directory.BasicAttribute"%><%@page import="javax.naming.directory.BasicAttributes"%>
<%@page import="org.semanticwb.portal.admin.resources.SWBASearchUsers"%><%@page import="org.semanticwb.SWBUtils"%><%@page import="org.semanticwb.Logger"%><%@page import="javax.naming.directory.SearchResult"%>
<%@page import="java.util.List"%><%@page import="java.util.ArrayList"%><%@page import="java.util.HashMap"%><%@page import="java.util.Map"%><%@page import="java.util.StringTokenizer"%><%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%><%@page import="javax.naming.NamingEnumeration"%><%@page import="javax.naming.directory.SearchControls"%><%@page import="javax.naming.directory.InitialDirContext"%><%@page import="javax.naming.Context"%><%@page import="javax.naming.directory.DirContext"%>
<%@page import="java.util.Hashtable"%><%@page import="java.util.Comparator"%><%@page import="javax.naming.NamingException"%><%@page import="org.semanticwb.model.User"%><%@page import="javax.naming.directory.Attributes"%>
<%@page import="java.util.Properties"%><%@page import="org.semanticwb.model.UserRepository"%><jsp:useBean id="paramRequest" scope="request" type="org.semanticwb.portal.api.SWBParamRequest"/>

<%!
    private final Logger log = SWBUtils.getLogger(SWBASearchUsers.class);

    private class UserInformationComparator implements Comparator
    {
        public int compare(Object o1, Object o2)
        {
            if(o1 instanceof UserInformation && o2 instanceof UserInformation)
            {
                return ((UserInformation)o1).name.compareToIgnoreCase(((UserInformation)o2).name);
            }
            else
            {
                return 0;
            }
        }
       
        
    }

    private class ConfigurationError extends Exception
    {

        public ConfigurationError(String message)
        {
            super(message);
        }
    }

    private class UserInformation
    {

        public String login, name;

        public UserInformation(String login, String name)
        {
            this.login = login;
            this.name = name;
        }
       
    }

    private class Util
    {

        private final UserRepository userRep;

        /**
         * The props.
         */
        private final Properties props;

        /**
         * The seek field.
         */
        private final String seekField;

        /**
         * The user object class.
         */
        private final String userObjectClass;

        /**
         * The field first name.
         */
        private final String fieldFirstName;

        /**
         * The field last name.
         */
        private final String fieldLastName;

        /**
         * The field middle name.
         */
        private final String fieldMiddleName;

        /**
         * The field email.
         */
        private final String fieldEmail;

        /**
         * The value language.
         */
        private final String valueLanguage;

        public Util(UserRepository UserRep, Properties props)
        {
            this.userRep = UserRep;
            this.props = props;
            this.seekField = props.getProperty("seekField", "uid");
            this.userObjectClass = props.getProperty("userObjectClass", "inetPerson");
            this.fieldFirstName = props.getProperty("fieldFirstName", "givenName");
            this.fieldLastName = props.getProperty("fieldLastName", "sn");
            this.fieldMiddleName = props.getProperty("fieldMiddleName", "null");
            this.fieldEmail = props.getProperty("fieldEmail", "mail");
            this.valueLanguage = props.getProperty("valueLanguage", "");
        }

        public void loadAttrs2RecUser(Attributes attrs, User ru)
        {

            try
            {
                if (!"null".equals(fieldFirstName))
                {
                    if (attrs != null && attrs.get(fieldFirstName) != null && attrs.get(fieldFirstName).get() != null)
                    {
                        ru.setFirstName((String) attrs.get(fieldFirstName).get());
                    }
                }
            }
            catch (NamingException ne)
            {
            }
            try
            {
                if (!"null".equals(fieldLastName))
                {
                    if (attrs != null && attrs.get(fieldLastName) != null && attrs.get(fieldLastName).get() != null)
                    {
                        ru.setLastName((String) attrs.get(fieldLastName).get());
                    }
                }
            }
            catch (NamingException ne)
            {
            }
            try
            { //If there is no middlename go on
                if (!"null".equals(fieldMiddleName))
                {
                    if (attrs != null && attrs.get(fieldMiddleName) != null && attrs.get(fieldMiddleName).get() != null)
                    {
                        ru.setSecondLastName((String) attrs.get(fieldMiddleName).get());
                    }
                }
            }
            catch (NamingException ne)
            {
                log.error(ne);
            }
            try
            {
                if (!"null".equals(fieldEmail))
                {
                    if (attrs != null && attrs.get(fieldEmail) != null && attrs.get(fieldEmail).get() != null)
                    {
                        ru.setEmail((String) attrs.get(fieldEmail).get());
                    }
                }
            }
            catch (NamingException ne)
            {
            }
            // If there is no language keep the default
            try
            {
                if (valueLanguage.startsWith("|"))
                {
                    ru.setLanguage(valueLanguage.substring(1));
                }
                else
                {
                    ru.setLanguage((String) attrs.get(valueLanguage).get());
                }
            }
            catch (NamingException ne)
            {
            }

        }

        public String getName(Attributes attrs)
        {
            StringBuilder sb = new StringBuilder();
            try
            {
                if (!"null".equals(fieldFirstName))
                {
                    //ru.setFirstName((String) attrs.get(fieldFirstName).get());
                    if (attrs != null && attrs.get(fieldFirstName) != null && attrs.get(fieldFirstName).get() != null)
                    {
                        sb.append(" ");
                        sb.append(attrs.get(fieldFirstName).get().toString());
                    }
                }
            }
            catch (NamingException ne)
            {
                log.error(ne);
            }
            try
            {
                if (!"null".equals(fieldLastName))
                {
                    //ru.setLastName((String) attrs.get(fieldLastName).get());
                    if (attrs != null && attrs.get(fieldLastName) != null && attrs.get(fieldLastName).get() != null)
                    {
                        sb.append(" ");
                        sb.append(attrs.get(fieldLastName).get().toString());

                    }
                }
            }
            catch (NamingException ne)
            {
                log.error(ne);
            }
            try
            { //If there is no middlename go on
                if (!"null".equals(fieldMiddleName))
                {
                    //ru.setSecondLastName((String) attrs.get(fieldMiddleName).get());

                    if (attrs != null && attrs.get(fieldMiddleName) != null && attrs.get(fieldMiddleName).get() != null)
                    {
                        sb.append(" ");
                        sb.append(attrs.get(fieldMiddleName).get().toString());
                    }

                }
            }
            catch (NamingException ne)
            {
                log.error(ne);
            }
            return sb.toString().trim();

        }

        private Hashtable getPropertiesHash()
        {
            Hashtable env = new Hashtable();
            env.put(Context.INITIAL_CONTEXT_FACTORY,
                    props.getProperty("factory", "com.sun.jndi.ldap.LdapCtxFactory"));
            env.put(Context.PROVIDER_URL, props.getProperty("url", "ldap://localhost"));
            env.put(Context.SECURITY_PRINCIPAL, props.getProperty("principal", ""));
            env.put(Context.SECURITY_CREDENTIALS, props.getProperty("credential", ""));
            return env;
        }

        private String getCNFromLogin(String login) throws NamingException
        {
            DirContext ctx = new InitialDirContext(getPropertiesHash());
            SearchControls ctls = new SearchControls();
            ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);
            try
            {
                NamingEnumeration answers = ctx.search(props.getProperty("base", ""),
                        "(&(objectClass=" + userObjectClass + ")(" + seekField + "=" + login + "))", ctls);

                return ((SearchResult) answers.next()).getName() + "," + props.getProperty("base", "");
            }
            catch (NamingException e)
            {
                log.trace(e);
                return null; //We didn't found or we got an error so we leave
            }
        }

        public Attributes getUserAttributes(String login) throws NamingException
        {
            DirContext ctx = new InitialDirContext(getPropertiesHash());
            String[] attrIDs =
            {
                "*"
            };
            String cn = getCNFromLogin(login);
            Attributes answer = ctx.getAttributes(cn, attrIDs);
            ctx.close();
            return answer;
        }

        private NamingEnumeration searchUser(String firstName, String lastName, String middleName, String email) throws NamingException
        {
            DirContext ctx = new InitialDirContext(getPropertiesHash());

            Attributes matchAttrs = new BasicAttributes(true); // ignore case
            matchAttrs.put(new BasicAttribute("objectClass", userObjectClass));
            // Search for objects that have those matching attributes

            SearchControls ctls = new SearchControls();
            ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);
            ctls.setReturningAttributes(new String[]
            {
                seekField
            });
            StringBuilder query = new StringBuilder("(&");
            query.append("(objectClass=").append(userObjectClass).append(")");
            if (firstName != null && !firstName.isEmpty() && !"null".equals(fieldFirstName))
            {
                query.append("(").append(fieldFirstName).append("=").append("*").append(firstName).append("*").append(")");
            }
            if (lastName != null && !lastName.isEmpty() && !"null".equals(fieldLastName))
            {
                query.append("(").append(fieldLastName).append("=").append("*").append(lastName).append("*").append(")");
            }
            if (middleName != null && !middleName.isEmpty() && !"null".equals(fieldMiddleName))
            {
                query.append("(").append(fieldMiddleName).append("=").append("*").append(middleName).append("*").append(")");
            }
            if (email != null && !email.isEmpty() && !"null".equals(fieldEmail))
            {
                query.append("(").append(fieldEmail).append("=").append("*").append(email).append("*").append(")");
            }
            query.append(")");

            NamingEnumeration answers = ctx.search(props.getProperty("base", ""),
                    query.toString(), ctls);
            ctx.close();
            return answers;
        }

        private User getUserByLogin(String login)
        {
            login=login.toLowerCase();
            User getUserByLogin = null;
            Iterator<User> users = userRep.listUsers();
            while (users.hasNext())
            {
                User temp = users.next();
                if (temp.getLogin().equals(login))
                {
                    getUserByLogin = temp;
                }
            }
            return getUserByLogin;
        }

        public String loadUser(String login)
        {
            login=login.toLowerCase();
            User user = getUserByLogin(login);
            try
            {
                Attributes atts = getUserAttributes(login);
                if (user == null)
                {
                    user = userRep.createUser();
                    user.setLogin(login);
                    user.setActive(true);
                }
                loadAttrs2RecUser(atts, user);
                return user.getFullName();
            }
            catch (NamingException ne)
            {
                log.error(ne);
            }
            return null;
        }

        private Set<String> getValues(String value)
        {
            Set<String> getValues = new HashSet<String>();
            if (value != null && !value.trim().isEmpty())
            {
                StringTokenizer st = new StringTokenizer(value, ",");
                while (st.hasMoreTokens())
                {
                    String token = st.nextToken().trim();
                    if (!token.isEmpty())
                    {
                        getValues.add(token);
                    }
                }
            }
            if (getValues.isEmpty())
            {
                getValues.add("");
            }
            return getValues;
        }

        public Map<String, String> findUsers(String pfirstName, String plastName, String pmiddleName, String pemail)
        {
            Map<String, String> findUsers = new HashMap<String, String>();

            Set<String> names = getValues(pfirstName);
            Set<String> lastNames = getValues(plastName);
            Set<String> middleNames = getValues(pmiddleName);
            Set<String> emails = getValues(pemail);

            for (String firstName : names)
            {
                for (String lastName : lastNames)
                {
                    for (String middleName : middleNames)
                    {
                        for (String email : emails)
                        {
                            try
                            {
                                NamingEnumeration answers = searchUser(firstName, lastName, middleName, email);
                                List<SearchResult> results = new ArrayList<SearchResult>();
                                try
                                {
                                    while (answers.hasMore())
                                    {

                                        Object answer = answers.next();
                                        if (answer instanceof SearchResult)
                                        {
                                            SearchResult searchResult = (SearchResult) answer;
                                            results.add(searchResult);
                                        }
                                    }
                                }
                                catch (NamingException ne)
                                {
                                    log.error(ne);
                                }
                                for (SearchResult searchResult : results)
                                {
                                    if (searchResult.getAttributes() != null && searchResult.getAttributes().get(seekField) != null && searchResult.getAttributes().get(seekField).get() != null)
                                    {
                                        String login = searchResult.getAttributes().get(seekField).get().toString();
                                        login=login.toLowerCase();
                                        if (!findUsers.containsKey(login))
                                        {
                                            Attributes atts = getUserAttributes(login);
                                            String name = getName(atts);
                                            findUsers.put(login, name);
                                        }
                                    }
                                }
                            }
                            catch (NamingException ne)
                            {
                                log.error(ne);
                            }
                        }
                    }
                }
            }
            return findUsers;
        }

    }
%>


<%
    String usrep = request.getParameter("userRepository");
    if (usrep == null)
    {
        return;
    }
    UserRepository repository = UserRepository.ClassMgr.getUserRepository(usrep);
    String loginContext = repository.getLoginContext();
   
    if ("LDAPModule".equals(loginContext))
    {
        String file = repository.getUserRepExternalConfigFile();
   
        if (file != null)
        {
            InputStream inProps = this.getClass().getClassLoader().getResourceAsStream(file);   
            if (inProps != null)
            {
  
                Properties props = new Properties();
                props.load(inProps);
                Util util = new Util(repository, props);
                Map<String, String> findUsers = util.findUsers(request.getParameter("usrFirstName"), request.getParameter("usrLastName"), request.getParameter("usrSecondLastName"), request.getParameter("usrEMail"));
                if (!findUsers.isEmpty())
                {
                    String[] users = (String[]) request.getSession().getAttribute("iteraUsers");
                    Set<String> delete = new HashSet<String>();
                    for (String userTxt : users)
                    {
                        User usr = (User) SWBPlatform.getSemanticMgr().getOntology().getGenericObject(userTxt);
                        if (usr != null)
                        {
                            String login = usr.getLogin();
                            if (login != null)
                            {                                
                                login=login.toLowerCase();
                                if(findUsers.keySet().contains(login))
                                {
                                    delete.add(login);
                                }
                                
                            }
                        }
                    }
                    for (String loginDelete : delete)
                    {
                        findUsers.remove(loginDelete);
                    }
                    if (!findUsers.isEmpty())
                    {
                        out.println("<script type=\"text/javascript\">");

                        out.println("function validaRep()");
                        out.println("{");

                        out.println("document.getElementsByName('frmsync')[0].submit();");
                        out.println("}");
                        out.println("function addAll()");
                        out.println("{");
                        out.println("var checkboxes = document.getElementsByName('login');\r\n"
                                + "  for(var i=0, n=checkboxes.length;i<n;i++)\n"
                                + "    checkboxes[i].checked = true;\r\n");
                        out.println("}");
                        out.println("</script>");
                        out.println("<fieldset name=\"frmAdmRes\">");
                        out.println("<legend>Usuarios encontrados en LDAP</legend>");
                        String url = paramRequest.getRenderUrl().setAction("search").toString();
                        out.println("<form class=\"swbform\" name=\"frmsync\" action=\"" + url + "\" method=\"post\">");
                        String userRepository = request.getParameter("userRepository");
                        if (userRepository == null)
                        {
                            userRepository = "";
                        }
                        String usrFirstName = request.getParameter("usrFirstName");
                        if (usrFirstName == null)
                        {
                            usrFirstName = "";
                        }
                        String usrLastName = request.getParameter("usrLastName");
                        if (usrLastName == null)
                        {
                            usrLastName = "";
                        }
                        String usrSecondLastName = request.getParameter("usrSecondLastName");
                        if (usrSecondLastName == null)
                        {
                            usrSecondLastName = "";
                        }
                        String usrEMail = request.getParameter("usrEMail");
                        if (usrEMail == null)
                        {
                            usrEMail = "";
                        }
                        out.println("<input type=\"hidden\" name=\"userRepository\" value=\"" + userRepository + "\">");
                        out.println("<input type=\"hidden\" name=\"usrFirstName\" value=\"" + usrFirstName + "\">");
                        out.println("<input type=\"hidden\" name=\"usrLastName\" value=\"" + usrLastName + "\">");
                        out.println("<input type=\"hidden\" name=\"usrSecondLastName\" value=\"" + usrSecondLastName + "\">");
                        out.println("<input type=\"hidden\" name=\"usrEMail\" value=\"" + usrEMail + "\">");
                        out.println("<table>");
                        List<UserInformation> usersFound = new ArrayList<UserInformation>();
                        for (String login : findUsers.keySet())
                        {
                            String name = findUsers.get(login);
                            usersFound.add(new UserInformation(login, name));
                        }
                        Collections.sort(usersFound, new UserInformationComparator());
                        for (UserInformation user : usersFound)
                        {
                            out.println("<input type=\"checkbox\" name=\"login\" value=\"" + user.login + "\">" + user.name + "<br>");
                        }
                        out.println("<br><br><button dojoType='dijit.form.Button' type=\"button\" onclick=\"addAll();\">Selecionar todos</button>&nbsp;&nbsp;<button dojoType='dijit.form.Button' type=\"button\" onclick=\"validaRep();\">Agregar</button>");
                        out.println("</form>");
                        out.println("</fieldset>");
                    }
                }

            }

        }
    }
%>
