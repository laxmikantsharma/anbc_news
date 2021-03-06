﻿using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace ANBCNews.Model.News
{
    public class NewsHeadline
    {
        public long NewsID { get; set; }

        public string Headline { get; set; }
        public string NewsType { get; set; }
        private string _ImagePath = "";
        public string ImagePath
        {
            get { return this._ImagePath; }
            set { this._ImagePath = (!string.IsNullOrEmpty(value) ? ConfigurationSetting.ImageWebUrl+ value : "");}
        }
        public string PageUrl { get; set; }
        public string TypeUrl { get; set; }
        public string QueryParam
        {
            get { return (!string.IsNullOrEmpty(PageUrl) ? PageUrl.Replace(" ", "-").ToLower() + "-" + NewsID.ToString() : NewsID.ToString()); }
            set { }
        }
        public string SubContent { get; set; }
        public DateTime PublishedDate { get; set; }
        private string _strPublishedDate;
        public string strPublishedDate
        {
            get { return (string.IsNullOrEmpty(_strPublishedDate) ? PublishedDate.ToString("dd MMM yyyy", new CultureInfo("hi")) : _strPublishedDate); }
            set { _strPublishedDate = value; }
        }
        public int TotalRecored { get; set; }
        public bool IsVideo { get; set; }
        public string VideoTime { get; set; }
    }
    public class NewsParam
    {
        public long NewsID { get; set; }
        public int PageNo { get; set; }
        public int SectionID { get; set; }
        public int NewsTypeID { get; set; }
        public bool OnlyVideo { get; set; }
    }
}
