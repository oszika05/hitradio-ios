//
//  NewsItemPage.swift
//  hitradio-ios
//
//  Created by Zsolt Oszlányi on 2021. 10. 22..
//

import SwiftUI

struct NewsItemPage: View {
    
    @ObservedObject private var viewModel: NewsItemPageViewModel
    
    init(news: News) {
        viewModel = NewsItemPageViewModel(news: news)
    }
    
    init(id: String) {
        viewModel = NewsItemPageViewModel(id: id)
    }
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            }
            
            if viewModel.isLoading == false && viewModel.news == nil {
                Text("404")
            }
            
            if !viewModel.isLoading && viewModel.news != nil {
                VStack {
                    Text(viewModel.news?.title ?? "")
                    Text(viewModel.news?.content ?? "")
                }
            }
            
            Spacer()
        }
    }
}

struct NewsItemPage_Previews: PreviewProvider {
    static var previews: some View {
        NewsItemPage(id: "alma")
    }
}
