using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Reflection;
using System.Security.Cryptography;
using System.Net;
using System.Text;


namespace dk.certifikat.tuexample.util
{
    public class ResourceHelper
    {
        private readonly HashAlgorithm _hashAlgorithm;

        public ResourceHelper()
        {
            _hashAlgorithm = SHA256.Create();
        }

        public String ReadFileFromURL(string url)
        {
            WebRequest request = HttpWebRequest.Create(url);
            WebResponse response = request.GetResponse();
            Stream receiveStream = response.GetResponseStream();

            // Pipes the stream to a higher level stream reader with the required encoding format. 
            StreamReader readStream = new StreamReader(receiveStream);
            String content = readStream.ReadToEnd();
            Console.WriteLine("Response stream received.");
            Console.WriteLine(content);
            response.Close();
            readStream.Close();

            return content;
        }

        public byte[] readFileContentFromURL(String url)
        {
            return new WebClient().DownloadData(url);
        }

        public string CreateHashValue(byte[] data)
        {
            return Base64Encode(_hashAlgorithm.ComputeHash(data));
        }

        private static string Base64Encode(byte[] bytes)
        {
            return Convert.ToBase64String(bytes);
        }

        public string ConvertRelativeUrlToAbsoluteUrl(string relativeUrl, HttpRequest Request, System.Web.UI.Page page)
        {
            if (Request.IsSecureConnection)
                return string.Format("https://{0}{1}{2}", Request.Url.Host, ":"+Request.Url.Port, page.ResolveUrl(relativeUrl));
            else
                return string.Format("http://{0}{1}{2}", Request.Url.Host, ":" + Request.Url.Port, page.ResolveUrl(relativeUrl));
        }

        public string Base64Encode(string text)
        {
            var bytes = Encoding.UTF8.GetBytes(text);
            return Convert.ToBase64String(bytes);
        }

        public string Base64Decode(string s)
        {
            var bytes = Convert.FromBase64String(s);
            return Encoding.UTF8.GetString(bytes);
        }
    }
}