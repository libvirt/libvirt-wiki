<?php
/**
 * Libvirt - Libvirt styled version of Vector
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 * http://www.gnu.org/copyleft/gpl.html
 *
 * @file
 * @ingroup Skins
 */

/**
 * SkinTemplate class for Libvirt skin
 * @ingroup Skins
 */
class SkinLibvirt extends SkinTemplate {
	public $skinname = 'libvirt';
	public $stylename = 'Libvirt';
	public $template = 'LibvirtTemplate';
	/**
	 * @var Config
	 */
	private $libvirtConfig;

	public function __construct() {
		$this->libvirtConfig = ConfigFactory::getDefaultInstance()->makeConfig( 'libvirt' );
	}

	/**
	 * Initializes output page and sets up skin-specific parameters
	 * @param OutputPage $out Object to initialize
	 */
	public function initPage( OutputPage $out ) {
		parent::initPage( $out );

		if ( $this->libvirtConfig->get( 'LibvirtResponsive' ) ) {
			$out->addMeta( 'viewport', 'width=device-width, initial-scale=1' );
			$out->addModuleStyles( 'skins.libvirt.styles.responsive' );
		}

		// Append CSS which includes IE only behavior fixes for hover support -
		// this is better than including this in a CSS file since it doesn't
		// wait for the CSS file to load before fetching the HTC file.
		$min = $this->getRequest()->getFuzzyBool( 'debug' ) ? '' : '.min';
		$out->addHeadItem( 'csshover',
			'<!--[if lt IE 7]><style type="text/css">body{behavior:url("' .
				htmlspecialchars( $this->getConfig()->get( 'LocalStylePath' ) ) .
				"/{$this->stylename}/csshover{$min}.htc\")}</style><![endif]-->"
		);

                $out->addHeadItem('favicon',
			'<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
		         <link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"/>
		         <link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"/>
		         <link rel="manifest" href="/manifest.json"/>
		         <meta name="theme-color" content="#ffffff"/>');


		$out->addModules( array( 'skins.libvirt.js' ) );
	}

	/**
	 * Loads skin and user CSS files.
	 * @param OutputPage $out
	 */
	function setupSkinUserCss( OutputPage $out ) {
		parent::setupSkinUserCss( $out );

		$styles = array( 'mediawiki.skinning.interface', 'skins.libvirt.styles' );
		Hooks::run( 'SkinLibvirtStyleModules', array( $this, &$styles ) );
		$out->addModuleStyles( $styles );
	}

	/**
	 * Override to pass our Config instance to it
	 */
	public function setupTemplate( $classname, $repository = false, $cache_dir = false ) {
		return new $classname( $this->libvirtConfig );
	}
}
