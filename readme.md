<div align="center">

<img src="./assets/zen-dark.svg" width="100px">

# <samp>🌟 Zen Browser for NixOS 🌟</samp>

![GitHub Repo stars](https://img.shields.io/github/stars/Gurjaka/zen-browser-nix?style=for-the-badge&labelColor=2e3440&color=5e81ac) ![GitHub last commit](https://img.shields.io/github/last-commit/Gurjaka/zen-browser-nix?style=for-the-badge&labelColor=2e3440&color=5e81ac) ![GitHub repo size](https://img.shields.io/github/repo-size/Gurjaka/zen-browser-nix?style=for-the-badge&labelColor=2e3440&color=5e81ac)

## <samp>🌀 Zen Browser is a **minimalist browser** designed to maximize your **productivity** by reducing distractions. This repository aims to **port Zen Browser** to **NixOS** using **flakes**.</samp>

</div>

## 📥 Installation

### NixOS or Home Manager

1. Add the following to your `flake.nix`:

    ```nix
    inputs = {
      zen-browser.url = "github:Gurjaka/zen-browser-flake";
      ...
    }
    ```

2. Then, add Zen Browser to your packages:
    > For system wide installation in *configuration.nix*
    ```nix
    environment.systemPackages = [
      inputs.zen-browser.packages."${system}".default;
    ];
    ```

    > For user level installation in *home.nix*
    ```nix
    home.packages = [
      inputs.zen-browser.packages."${system}".default;
    ];
    ```

## 🚀 Usage

Launch Zen Browser by running the following command:

```bash
zen
```

## 🔧 Configuration

Zen Browser is highly customizable. Explore the settings folder to make adjustments based on your preferences.

## 💬 Contributing

We ❤️ contributions! Feel free to fork the repository, create a branch, and submit a pull request to enhance Zen Browser.

### How to Contribute
1. Fork the repository.
2. Create a new branch.
3. Make your changes and commit them.
4. Open a pull request with a clear description of the changes.

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](./LICENSE) file for more details.
