using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace dk.certifikat.tuexample.util
{
    public sealed class RequestValidator
    {
        private static readonly RequestValidator instance = new RequestValidator();

        private RequestValidator() { }
        
        public static RequestValidator Instance
        {
            get
            {
                return instance;
            }
        }

        public static String getValidatedEncodedParam(String reqParam)
        {
            if(reqParam == null || "".Equals(reqParam))
                return "";

            return HttpUtility.HtmlEncode(reqParam);
        }

        public static String getValidatedEncodedParam(String paramName, String reqParam, int maxLength)
        {
            if (reqParam == null || "".Equals(reqParam))
                return "";

            //check length of param
            if (reqParam.Length > maxLength)
                throw new ArgumentException("Fejl - Request parameter: "+paramName+" overskrider max tilladt længde");
            
            return getValidatedEncodedParam(reqParam);
        }

        public static String getValidatedParam(String paramName, String reqParam, int maxLength)
        {
            if (reqParam == null || "".Equals(reqParam))
            {
                return "";
            }
            if (reqParam.Length > maxLength)
            {
                throw new ArgumentException("Fejl - request parameter: " + paramName + " indeholder mere data end tilladt.");
            }
            return reqParam;
        }
    }
}