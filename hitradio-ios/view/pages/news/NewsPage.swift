import SwiftUI
import URLImage

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
                    Text(item.title).onAppear {
                        if self.viewModel.news.last == item {
                            self.viewModel.fetchNext()
                        }
                    }
                }
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct NewsPage_Previews: PreviewProvider {
    static var previews: some View {
        NewsPage()
    }
}
