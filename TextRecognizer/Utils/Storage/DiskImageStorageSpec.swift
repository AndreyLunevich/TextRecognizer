import Quick
import Nimble
@testable import TextRecognizer

final class DiskImageStorageSpec: QuickSpec {

    override func spec() {

        describe("DiskImageStorage") {

            var storage: DiskImageStorage!
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("test")

            beforeEach {
                storage = DiskImageStorage()
            }

            afterEach {
                try? FileManager.default.removeItem(at: url)
            }

            describe("save image") {

                context("when parent folder already exist") {

                    it("will save image successfully") {
                        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

                        expect { try storage.save(UIImage(), url: url.appendingPathComponent("some-image")) }.toNot(throwError())
                    }
                }

                context("when have good image") {

                    it("will save image successfully") {
                        expect { try storage.save(UIImage(), url: url.appendingPathComponent("some-image")) }.toNot(throwError())
                    }
                }
            }
        }
    }
}
