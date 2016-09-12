//
//  MusicTableViewController.swift
//  MusicLibrary
//
//  Created by Thales Toniolo on 10/19/14.
//  Copyright (c) 2014 FIAP. All rights reserved.
//
import UIKit
import MediaPlayer

class MusicTableViewController: UITableViewController {

	var arrMusicas:Array<AnyObject>?
	var musicPlayer:MPMusicPlayerController?
	var currentIndexPath:NSIndexPath?

	//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

		// Carrega o array com as musicas na lib
		self.carregarMusicasIpod()
    }

	//MARK: - Private Methods
	func carregarMusicasIpod() {
		/* --- Opcoes de musicas a serem recuperadas
		+ (MPMediaQuery *)albumsQuery;
		+ (MPMediaQuery *)artistsQuery;
		+ (MPMediaQuery *)songsQuery;
		+ (MPMediaQuery *)playlistsQuery;
		+ (MPMediaQuery *)podcastsQuery;
		+ (MPMediaQuery *)audiobooksQuery;
		+ (MPMediaQuery *)compilationsQuery;
		+ (MPMediaQuery *)composersQuery;
		+ (MPMediaQuery *)genresQuery;
		*/
		// Monta o array com as musicas do ipod do device
		let libMusicas:MPMediaQuery = MPMediaQuery.songsQuery()

		// Recupera os itens da music library
		self.arrMusicas = libMusicas.items

		// Prepara o music player da library
		self.musicPlayer = MPMusicPlayerController.applicationMusicPlayer()
	}

    // MARK: - UITableViewDelegate e UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMusicas!.count
    }

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath:indexPath) as UITableViewCell
		
		// Recupera uma musica, aqui consegue pegar todas propriedades dela (quanto mais organizada a biblioteca do usuario, mais informacoes havera)
		let musicItem:MPMediaItem = self.arrMusicas![indexPath.row] as! MPMediaItem
		cell.textLabel!.font = UIFont.systemFontOfSize(14)
		cell.textLabel!.text = "\(musicItem.valueForProperty(MPMediaItemPropertyTitle)) - \(musicItem.valueForProperty(MPMediaItemPropertyArtist)) | \(musicItem.valueForProperty(MPMediaItemPropertyPlaybackDuration))"
		cell.accessoryType = UITableViewCellAccessoryType.None
		if (self.currentIndexPath == indexPath) {
			cell.accessoryType = UITableViewCellAccessoryType.Checkmark
		}

		// Algumas outras propriedades da musica...
//		println("Musica: \(musicItem.valueForProperty(MPMediaItemPropertyTitle))")
//		println("Album: \(musicItem.valueForProperty(MPMediaItemPropertyAlbumTitle))")
//		println("Autor: \(musicItem.valueForProperty(MPMediaItemPropertyArtist))")
//		println("Genero: \(musicItem.valueForProperty(MPMediaItemPropertyGenre))")
//		println("Duracao: \(musicItem.valueForProperty(MPMediaItemPropertyPlaybackDuration))")
//		println("----------------------------------")

		return cell
	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		if (self.currentIndexPath == indexPath) {
			// Para a musica corrente, caso esteja tocando
			self.musicPlayer!.stop()
			self.currentIndexPath = NSIndexPath(forRow: -1, inSection: -1)
		} else {
			// Monta a colecao para tocar a musica selecionada...
			self.currentIndexPath = indexPath
			let musicItem:MPMediaItem = self.arrMusicas![indexPath.row] as! MPMediaItem
			let arrCollectionToPlay:MPMediaItemCollection = MPMediaItemCollection(items: [musicItem])
			self.musicPlayer?.setQueueWithItemCollection(arrCollectionToPlay)
			self.musicPlayer?.play()
		}

		// Refresh na tabela
		self.tableView.reloadData()
	}

	//MARK: - Memory Management
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}
