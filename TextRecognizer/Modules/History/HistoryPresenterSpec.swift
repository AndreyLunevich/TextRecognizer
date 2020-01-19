import Quick
import Nimble
@testable import TextRecognizer

final class HistoryPresenterSpec: QuickSpec {

    override func spec() {

        describe("HistoryPresenter") {

            describe("load history") {

                context("when loading was failed") {

                    it("will show error alert") {
                        let router = HistoryRouterMock()
                        let worker = RecognitionWorkerMock(result: .failure(NSError(domain: "", code: 666, userInfo: nil)))
                        let presenter = HistoryPresenter(router: router, worker: worker)

                        var displayCalled = false
                        presenter.display = {
                            displayCalled = true
                        }

                        presenter.setup(from: UIViewController())

                        expect(displayCalled).toEventually(beFalse())
                        expect(router.alertPresented).toEventually(beTrue())
                    }
                }

                context("when loading was successed") {

                    it("will show loaded data") {
                        let router = HistoryRouterMock()
                        let worker = RecognitionWorkerMock(result: .success([]))
                        let presenter = HistoryPresenter(router: router, worker: worker)

                        var displayCalled = false
                        presenter.display = {
                            displayCalled = true
                        }

                        presenter.setup(from: UIViewController())

                        expect(displayCalled).toEventually(beTrue())
                        expect(router.alertPresented).toEventually(beFalse())
                    }
                }
            }
        }
    }
}

fileprivate final class RecognitionWorkerMock: RecognitionWorker {

    private let result: Result<[Recognition], Error>

    init(result: Result<[Recognition], Error>) {
        self.result = result
    }

    override func findAll(completion: @escaping (Result<[Recognition], Error>) -> Void) {
        completion(result)
    }
}

fileprivate final class HistoryRouterMock: HistoryRouter {

    private(set) var alertPresented = false

    func presentInfoAlert(from controller: UIViewController, title: String?, message: String?, handler: (() -> Void)?) {
        alertPresented = true
    }
}
