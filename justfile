set shell := ["powershell.exe", "-c"]

default: gen lint

llvm_path := if os() == "macos" {
    "--llvm-path /opt/homebrew/opt/llvm"
} else {
    "--llvm-path C:/Software/LLVM"
}

gen:
    flutter pub get
    flutter_rust_bridge_codegen \
        --rust-input native/src/api.rs \
        --dart-output lib/bridge_generated.dart \
        --c-output ios/Runner/bridge_generated.h \
        --dart-decl-output lib/bridge_definitions.dart \
        --wasm \
        --llvm-path C:/Software/LLVM
    cp ios/Runner/bridge_generated.h macos/Runner/bridge_generated.h
    flutter pub run build_runner build

lint:
    cd native; cargo fmt
    dart format .

clean:
    flutter clean
    cd native; cargo clean
    
serve *args='':
    flutter pub run flutter_rust_bridge:serve {{args}}

# vim:expandtab:sw=4:ts=4
