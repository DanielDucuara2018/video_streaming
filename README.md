# 📺 Video Streaming Platform

The **Video Streaming Platform** is a self-hosted media server solution designed to manage and stream your personal media library. Leveraging powerful tools like Emby, qBittorrent, Radarr, Sonarr, and Prowlarr, this platform provides an integrated environment for downloading, organizing, and streaming movies and TV shows.

---

## 🚀 Features

- **Emby Media Server**: Stream your personal media library to various devices with a user-friendly interface.
- **Automated Downloads**:
  - **qBittorrent**: Efficient torrent client for downloading media.
  - **Radarr**: Automates movie downloads, ensuring your collection is always up-to-date.
  - **Sonarr**: Manages TV show downloads, tracking new episodes automatically.
  - **Prowlarr**: Acts as an indexer manager/proxy for both Radarr and Sonarr, supporting multiple indexers.

---

## 🧰 Included Applications

- [Emby](https://emby.media/)
- [qBittorrent](https://www.qbittorrent.org/)
- [Radarr](https://radarr.video/)
- [Sonarr](https://sonarr.tv/)
- [Prowlarr](https://wiki.servarr.com/prowlarr)

---

## 🛠️ Prerequisites

- **Docker**: Ensure Docker is installed on your system. [Install Docker](https://docs.docker.com/get-docker/)
- **Docker Compose**: Required for orchestrating multi-container Docker applications. [Install Docker Compose](https://docs.docker.com/compose/install/)

---

## ⚙️ Installation & Setup

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/DanielDucuara2018/video_streaming.git
   cd video_streaming
   ````

2. **Configure Environment Variables**:

   Create a `.env` file in the root directory and define necessary environment variables as required by your setup.

3. **Launch the Stack**:

   Use Docker Compose to build and start all services:

   ```bash
   docker-compose up -d
   ```

   *Note*: Ensure that the `docker-compose.yml` file is properly configured with the desired settings.

---

## 📁 Project Structure

```
video_streaming/
├── deploy/                       # Deployment scripts and configurations
├── resources/                    # Static resources and assets
├── docker-compose.apparr.yml     # Docker Compose file for Apparr services
├── docker-compose.wireguard.yml  # Docker Compose file for WireGuard VPN
├── .gitignore                    # Git ignore file
├── README.md                     # Project documentation
```

---

## 🔧 Configuration

* **Emby**: Access the Emby web interface at `http://localhost:8096` after starting the containers.
* **qBittorrent**: Accessible at `http://localhost:8080` with default credentials (`admin` / `adminadmin`).
* **Radarr**: Available at `http://localhost:7878`.
* **Sonarr**: Available at `http://localhost:8989`.
* **Prowlarr**: Available at `http://localhost:9696`.

*Ensure to change default credentials and configure each service according to your preferences.*

---

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request for any enhancements or bug fixes.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
