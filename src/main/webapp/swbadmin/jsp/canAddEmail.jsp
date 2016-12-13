<%@page contentType="text/html"%><%@page pageEncoding="UTF-8"%><%@page import="org.semanticwb.*,org.semanticwb.platform.*,org.semanticwb.portal.*,org.semanticwb.model.*,java.util.*,org.semanticwb.base.util.*"%><%!
    boolean isValidEmail(String email)
    {
        boolean ret=true;
        if(email!=null && email.trim().length()>0)
        {
            if(email.indexOf("@")==-1 || email.indexOf(".")==-1 || email.indexOf(" ")>-1) ret=false;
        }else
        {
            ret=false;
        }
        return ret;
    }

%><%

    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Pragma", "no-cache");
    String email=request.getParameter("email");
    String model=request.getParameter("model");
    //System.out.println("login:"+login+" model:"+model);
    if(email==null || email.length()==0 || model==null)
    {
        out.println("false");
        //System.out.println("false");
    }else
    {
        if(isValidEmail(email))
        {
            User obj = SWBContext.getUserRepository(model).getUserByEmail(email);
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