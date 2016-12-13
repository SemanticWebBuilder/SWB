<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%><%!
    boolean isValidId(String id)
    {
        boolean ret=true;
        if(id!=null)
        {
            if(id.length()<3)
            {
                ret=false;
            }else
            {
                for(int x=0;x<id.length();x++)
                {
                    char ch=id.charAt(x);
                    if (!((ch >= '0' && ch <= '9') || (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '-' || ch == '_' || ch == '.' || ch == '@'))
                    {
                        ret=false;
                        break;
                    }
                }
             }
        }else
        {
            ret=false;
        }
        return ret;
    }

%><%
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    String login=request.getParameter("login");
    String model=request.getParameter("model");
    //System.out.println("login:"+login+" model:"+model);
    if(login==null || login.length()==0 || login.indexOf(' ')>-1 || model==null)
    {
        out.println("false");
        //System.out.println("false");
    }else
    {
        if(isValidId(login))
        {
            User obj = SWBContext.getUserRepository(model).getUserByLogin(login);

            if(obj!=null)
            {
                out.println("false");
                //System.out.println("false");
            }else
            {
                out.println("true");
                //System.out.println("true");
            }
        }else
        {
            out.println("false");
            //System.out.println("false");
        }
    }
%>