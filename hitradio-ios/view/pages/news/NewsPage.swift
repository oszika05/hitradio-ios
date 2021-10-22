import SwiftUI
import URLImage
import SwiftUIRouter

struct NewsPage: View {

    @ObservedObject var viewModel = NewsPageViewModel()

    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.search)


            List {
                ForEach(
                    viewModel.news,
                    id: \.id
                ) { item in
                    NavigationLink(destination: NewsItemPage(news: item)) {
                        Text(item.title).onAppear {
                            if self.viewModel.news.last == item {
                                self.viewModel.fetchNext()
                            }
                        }
                    }
//                    NavLink(to: "/news/\(item.id)") {
//                        Text(item.title).onAppear {
//                            if self.viewModel.news.last == item {
//                                self.viewModel.fetchNext()
//                            }
//                        }
//                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            
            Spacer()
        }
    }
}

struct NewsPage_Previews: PreviewProvider {
    static var previews: some View {
        NewsPage()
    }
}
