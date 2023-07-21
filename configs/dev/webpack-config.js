import PrConf from '../../src/initphp/ts/configs/project.js';
import Path from 'path';
import HtmlWebpackPlugin from 'html-webpack-plugin';
import CopyPlugin from 'copy-webpack-plugin';
import TerserPlugin from 'terser-webpack-plugin';
import MiniCssExtractPlugin from 'mini-css-extract-plugin';
import Glob from 'glob';
import { PurgeCSSPlugin } from 'purgecss-webpack-plugin';

function createCopyPath() {
    const path = [];
    const defC = PrConf.copy;
    for (const type in defC) {
        for (const frto in defC[type]) {
            path.push(defC[type][frto]);
        }
    }
    return path;
}

const BOpt = {
    presets: [
        ['@babel/preset-env', { targets: '>0.5%, not dead' }],
    ],
}

function getMode() {
    if (PrConf.production) {
        return 'production';
    }
    return 'development';
}

const config = {
    target: 'web',
    resolve: {
        extensions: [".tsx", ".ts", ".js"],
        alias: {
            '@initphp/src': Path.resolve(process.cwd(), 'src/initphp/ts/'),
            '@initphp/root': Path.resolve(process.cwd(), 'src/initphp/'),
            '@extra': Path.resolve(process.cwd(), 'extra/'),
            '@configs': Path.resolve(process.cwd(), 'configs/'),
            '@assets': Path.resolve(process.cwd(), 'assets/'),
        },
    },
    mode: getMode(),
    entry: {
        index: './src/initphp/ts/index.ts',
    },
    output: {
        filename: 'js/[name].[chunkhash].bundle.js',
        path: Path.resolve(process.cwd(), 'public/initphp/public'),
        publicPath: '/',
    },
    optimization: {
        runtimeChunk: 'single',
        splitChunks: { 
            cacheGroups: {
                vendor: {
                    test: /[\\/]node_modules[\\/]/,
                    chunks: "all"
                },
                style: {
                    name: 'style',
                    test: /(?<!\.module)\.css$/,
                    chunks: 'all',
                    enforce: true
                }
            },
        },
        minimize: PrConf.production,
        minimizer: [
            new TerserPlugin({
                extractComments: /^\**!|@preserve|@license|@cc_on/i,
                exclude: /vendor\//,
            }),
        ],
    },
    plugins: [
        new HtmlWebpackPlugin({
            filename: 'html/index.html',
            template: 'src/initphp/html/twig/index.html',
            chunks: ['index']
        }),
        new MiniCssExtractPlugin({
            filename: 'css/[name].[chunkhash].bundle.css',
        }),
        new PurgeCSSPlugin({
            paths: Glob.sync(`${process.cwd()}/src/initphp/**/*`,  { nodir: true }),
            only: ["vendor", "style"],
        }),
        new CopyPlugin({
            patterns: createCopyPath(),
        }),
    ],
    module: {
        rules: [
            {
                test: /\.tsx?$/,
                include: [ Path.resolve(process.cwd(), 'src/initphp/ts') ],
                use: [                    
                    {
                        loader: 'babel-loader',
                        options: BOpt,
                    },
                    { 
                        loader: 'ts-loader',
                        options: {
                            configFile: Path.resolve(process.cwd(), 'configs/dev/tsconfig.json')
                        }
                    }
                ],
            },
            {
                test: /\.css$/,
                include: [ Path.resolve(process.cwd(), 'src/initphp/css') ],
                use: [
                    MiniCssExtractPlugin.loader,
                    {
                        loader: 'css-loader',
                        options: {
                            importLoaders: 0,
                            modules: false,
                        },
                    },
                ],
                exclude: /\.module\.css$/,
            },
            {
                test: /\.module\.css$/,
                include: [ Path.resolve(process.cwd(), 'src/initphp/css') ],
                use: [
                    MiniCssExtractPlugin.loader,
                    {
                        loader: 'css-loader',
                        options: {
                            importLoaders: 1,
                            modules: true,
                        },
                    },
                ],
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                include: [ 
                    Path.resolve(process.cwd(), 'extra'),
                    Path.resolve(process.cwd(), 'assets') 
                ],
                type: 'asset/resource',
                generator: {
                    filename: 'fonts/[hash][ext][query]',
                },
            },
            {
                test: /\.(jpg|png)$/,
                include: [ 
                    Path.resolve(process.cwd(), 'extra'),
                    Path.resolve(process.cwd(), 'assets') 
                ],
                type: 'asset/resource',
                generator: {
                    filename: 'img/[hash][ext][query]',
                },
            },
            {
                test: /\.js$/,
                include: [ Path.resolve(process.cwd(), 'src/initphp/js') ],
                use: [
                    {
                        loader: 'babel-loader',
                        options: BOpt,
                    },
                ],
            },            
        ],
    },
    performance: {
        assetFilter: function (assetFilename) {
            return !assetFilename.startsWith('..');
        },
    },
};

export default config;
